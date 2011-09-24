require File.dirname(__FILE__) +'/../shell/shell_executor'

class ShellJob

  attr_reader :number_of_runs, :repeat, :period, :next_wakeup, :shells
  
  def initialize(params)

      if params[:repeat] == -1 or params[:repeat].nil?
        params[:repeat] == 999999
      end
      
      @config = params

      @period = params[:period]
      @repeat = params[:repeat]
      @verbose = params[:verbose]
      @passwd_file = params[:passwd_file]

      @shells = {}

      #puts "--- #{self} verbose=#{params[:verbose]}"

      @number_of_runs = 0
      @next_wakeup = Time.now 

  end
  
  def action
  end

  def run
    @number_of_runs = @number_of_runs + 1
    @next_wakeup = Time.now + period

    action  
  end

  def keepalive
    @shells.each do |hostname,shell|
      exec(hostname,"date")  
    end
  end
  
  def finished?
    number_of_runs > repeat
  end

  def close
    @shells.each do |hostname,shell|
      begin
        shell.close if shell
      rescue
        put "error when closing job's ssh connection "
      ensure
        @shells[hostname] = nil
      end
    end  
  end

  def after_create_shell(shell)
  end

  def exec(hostname,script)
    unless @shells[hostname]
      @shells[hostname] = ShellExecutor.new(:host=>hostname,:verbose=>@verbose,:passwd_file=>@passwd_file)

      after_create_shell(@shells[hostname])  
    end

    @shells[hostname].exec(script) 

  rescue =>e
    # check for Net::SSH::AuthenticationFailed 
    puts "error #{e.class} #{e.to_s} when executing script: #{script}"
    @shells[hostname]=nil
  end

  private :exec

end


