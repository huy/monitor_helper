require File.dirname(__FILE__) + '/scheduler'


Dir["#{File.dirname(__FILE__)}/*_job.rb"].each do |job|
   puts "-- job =#{job}"
   require job
end   

class Watcher
  
  def initialize(params)
    @config = {}
 
    params[:config_file].to_a.each do |config_file|
       puts "--- load #{config_file}"
       @config = @config.merge(YAML.load_file(config_file))
    end

    @config[:socket_port] ||= 9989
    @config[:parallel] ||= false

    @scheduler = Scheduler.new(:socket_port=>@config[:socket_port])
    create_jobs()
  end

  def create_jobs()

    @config[:watchlist].each do |params|
      params[:job_type] ||= @config[:job_type]
      params[:passwd_file] ||= @config[:passwd_file]

      klass = Object.const_get(params[:job_type]) if Object.const_defined?(params[:job_type]) 

      @scheduler.add_job(klass.new(@config, params))
      
    end
  
  end

  def watch
    if @config[:parallel]
      @scheduler.schedule_jobs_parallel
    else
      @scheduler.schedule_jobs_sequential
    end
  end   

end
