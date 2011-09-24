module WAS
  class Environment
    attr_accessor :timestamp, :pid, :processname
    
    def initialize(params={})
      @pid = params[:pid]
      @processname = params[:processname]
      @timestamp = params[:timestamp]
    end
  
    def self.parse(msg)
      result = Environment.new
  
      msg = msg.sub(/Start Display Current Environment.*\n/,'').sub(/\n.+End Display Current Environment/,'')
  
      regexp = /(process id)\s+(\d+)/
      match = regexp.match(msg)
      result.pid = match[2] if match
  
      regexp = /(process name)\s+(\S+)/
      match = regexp.match(msg)
      result.processname = match[2] if match
  
      result
    end
    
    def servername
      @processname.split("\\").last
    end
  
    def to_hash
      {:timestamp=>timestamp,:pid=>@pid,:processname=>@processname}
    end
    
  end
  
  class NormalEvent 
    attr_accessor :source, :timestamp, :thread_id, :component, :event_type, :message_id, :message
  
    def self.parse(msg)
      #<timestamp><threadID><component><eventType><messageId><message>
      regexp = /\A(\[.+\]) (\w+) (\w+)\s+(\w)\s+(\w+):(.*)\z/m
      match = regexp.match(msg)
      if match
        result = NormalEvent.new(
          :timestamp => parse_timestamp(match[1]),
          :thread_id => match[2],
          :component => match[3],
          :event_type => match[4],
          :message_id => match[5],
          :message => match[6])
      else #some event has not message_id
        regexp = /\A(\[.+\]) (\w+) (\w+)\s+(\w)\s+(.*)\z/m
        match = regexp.match(msg)
        if match
          result = NormalEvent.new(
            :timestamp => parse_timestamp(match[1]),
            :thread_id => match[2],
            :component => match[3],
            :event_type => match[4],
            :message_id => nil,
            :message => match[5])
        else
           puts "--- cannot parse event #{msg}" if msg and not msg.empty?    
        end
               
      end    
      result
    end
  
    def self.parse_timestamp(timestr)
      regexp = /\A\[(\d+)\/(\d+)\/(\d+) (\d+):(\d+):(\d+):(\d+) JST\]\z/
      match = regexp.match(timestr)
      if match 
        Time.local(match[3].to_i+2000,match[1],match[2],match[4],match[5],match[6],match[7].to_i*1000)
      end  
    end
  
    def self.load(params)
      NormalEvent.new(params)
    end
  
    def initialize(params={})
      @source = params[:source]
      @raw = params[:raw]
      @timestamp = params[:timestamp]
      @thread_id = params[:thread_id]
      @component = params[:component]
      @event_type = params[:event_type]
      @message_id = params[:message_id]
      @message = params[:message].strip if params[:message]
    end
  
    def to_hash
     { :timestamp => timestamp,
       :thread_id => thread_id,
       :component => component,
       :event_type => event_type,
       :message_id => message_id,
       :message => message
     }
    end
  
  end
end
