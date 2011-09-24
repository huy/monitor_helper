require File.dirname(__FILE__) +'/shell_job'
require File.dirname(__FILE__) +'/was_system_out_err'
require File.dirname(__FILE__) +'/was_event_filter'
require File.dirname(__FILE__) +'/stdout'
require File.dirname(__FILE__) +'/mail'

class WatchExceptionJob < ShellJob

  def initialize(config,params)
      config[:output] ||= config[:output] || 'Mail'
 
      params = config.merge(params)

      super params

      locations = params[:system_out_location] || params[:systemout_location]
      
      seconds_ago = params[:seconds_ago] || 0

      @last_event_at = {}

      @events_excluded = WAS::EventFilter.new(:include=>params[:exclude][:filter])
      
      @event_specs = []
      params[:significal][:events].each do |spec|
        @event_specs << {:filter=>WAS::EventFilter.new(:include=>spec[:filter]), :name=>spec[:name]}
      end

      @locations = locations.to_a.collect do |one|
        puts "--- "
        pp one
        p1,p2 = one.split(':')
        if p2
          hostname = p1
          path = p2
        else
          hostname = params[:host]
          path = p1
        end  

        {:host=>hostname,:path=>path}
      end

      @from_time = Time.now - seconds_ago

      @output = create_output(params)

  end

  def create_output(params)
    klass = Object.const_get(params[:output]) if Object.const_defined?(params[:output]) 
    klass.new(params)
  end

  def find(host,path)
    find_cmd = "find #{File.dirname(path)} -name \"#{File.basename(path)}\" "
    puts "[#{host}]--- #{find_cmd} "

    found = exec(host,find_cmd)
    result = if found
      found.split("\n") 
    else
      []
    end  

    result
  end

  def read(host,path)
    cat_cmd = "cat #{path}"
    puts "[#{host}]--- #{cat_cmd} "
    result = exec(host,cat_cmd)
    result
  end

  def incomming_events(host,path)
    result = []
    filelist = find(host,path)

    filelist.each do |one_file| 
      systemout = WAS::SystemOutErr.parse(read(host,one_file))
   
      puts "[#{host}] --- #{systemout.env.servername}" if systemout.env
      puts "\tnumber of parsed events of #{File.basename(one_file)} is #{systemout.events.size}"
  
      @last_event_at[one_file] ||= @from_time

      incomming = systemout.events.select{|event| event.timestamp > @last_event_at[one_file]}
      @last_event_at[one_file] = incomming.max {|a,b| a.timestamp <=> b.timestamp }.timestamp unless incomming.empty?

      puts "\tnumber of incomming events since #{@last_event_at[one_file]} is #{incomming.size}"

      result = result + incomming
  
    end  
    result
  end

  def specified(event)
    result = @event_specs.find{|spec| spec[:filter].satisfied?(event) }
    result
  end

  def action
    aggregated = []
    @locations.each do |one|
      aggregated = aggregated + 
        incomming_events(one[:host],one[:path]).select {
            |event| not @events_excluded.satisfied?(event)}
    end
    sorted = aggregated.sort_by {|event| event.timestamp}

    un_specified = []

    sorted.each do |event|
      spec = specified(event)

      if spec
        unless un_specified.empty?
           @output.send(:shells=>@shells,
                   :events=>un_specified,
                   :subject_matter=>@config[:exclude][:name],
                   :config=>@config)   
           un_specified = []
        end
        @output.send(:shells=>@shells,
                   :events=>[event],
                   :subject_matter=>spec[:name],
                   :config=>@config)
      else
        un_specified << event
      end
    end

    unless un_specified.empty?
      @output.send(:shells=>@shells,
            :events=>un_specified,
            :subject_matter=>@config[:exclude][:name],
            :config=>@config)   
    end
  end

end

