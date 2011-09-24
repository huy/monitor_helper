require 'socket'
require 'pp'

class Scheduler
    attr_reader :socket_port, :jobs
    
    def initialize(params={})
      @socket_port=params[:socket_port] 
      raise "missing socket_port " unless @socket_port
      @jobs = []
    end
    
    def add_job job
        jobs << job
    end
    
    def schedule_jobs_parallel
      guard(@socket_port) do
        
        threads = []
        puts "-- create working thread"
        jobs.each do |job|
            threads << Thread.new do
              (1..job.repeat).each do |n|
                job.run

                if n < job.repeat
                  puts "sleep #{job.period} seconds"
                  (job.period/keepalive_seconds).to_i.times do
                    sleep(job.period / keepalive_seconds)
                    job.keepalive 
                  end   
                  sleep(job.period % keepalive_seconds)
                end  
              end
              job.close
            end
        end

        puts "-- run #{threads.size} working threads "

        threads.each do |t|
            t.join
        end
        
      end
    end


    def schedule_jobs_sequential
      guard(@socket_port) do
        while not jobs.empty?

          now = Time.now
          
          jobs.select{|job| job.next_wakeup < now}.each do |job|
            job.run
          end

          remove_finished_jobs

          sleep_until_job_ready unless jobs.empty?

        end
      end  
    end

    def remove_finished_jobs
      @jobs.each do |job| 
        job.close if job.finished?
      end

      @jobs = @jobs.delete_if{|job| job.finished? }    
    end

    def sleep_until_job_ready
      now = Time.now
      top_job = jobs.min {|a,b| a.next_wakeup <=> b.next_wakeup }

      if (top_job.next_wakeup - now) > 0
        puts "--- sleep #{top_job.next_wakeup - now } seconds"

        ((top_job.next_wakeup - now)/keepalive_seconds).to_i.times do
          jobs.each do |job|
            sleep(keepalive_seconds/jobs.size)
            job.keepalive
          end
        end  

        sleep((top_job.next_wakeup - now) % keepalive_seconds)

      end 
    end

    def keepalive_seconds
      60
    end

    def guard(socket_port)

        raise "missing socket_port " unless socket_port

        begin
            server_socket=TCPServer.new('localhost',socket_port)
        rescue Errno::EBADF
            puts "process already running on socket #{socket_port}"
            exit 1
        end

        begin
            yield socket_port if block_given?
        ensure
            server_socket.close if server_socket
        end
    end
    
    private :guard, :remove_finished_jobs, :sleep_until_job_ready
end
