require 'yaml'

require File.dirname(__FILE__) + '/was_event'

module WAS
  class SystemOutErr
    attr_reader :events,:environment
  
    def self.load(filename)
      result = SystemOutErr.new(:localtion=>filename)
      YAML.load(File.read(filename)).each do |params|
        result.add_event(NormalEvent.load(params))
      end
      result 
    end
  
    def self.parse(content)
      result = SystemOutErr.new
  
      regexp = /\[\d{1,2}\/\d{1,2}\/\d{1,2} \d{1,2}:\d{2}:\d{2}:\d{3} JST\]/
      
      previous_match = nil
      remain_content = content
      while true  
        current_match = regexp.match(remain_content)
        if current_match
          result.process_chunk("#{previous_match}#{current_match.pre_match}")
          previous_match = current_match
          remain_content = current_match.post_match
        else
          result.process_chunk("#{previous_match}#{remain_content}")
          break
        end
      end
  
      result
  
    end
  
    def initialize(params={})
       @location = params[:location] || 'systemout.yml'
  
       @environment = Environment.new(:pid=>'',:processname=>'')
  
       @events = []
    end
  
    def process_chunk(raw)
      #puts "--- process #{raw}"
      if raw =~  /Start Display Current Environment.*End Display Current Environment/m    
        @environment = Environment.parse(raw) 
      else
        add_event(NormalEvent.parse(raw))
      end
    end
  
    def save(filename)
      File.open(filename,'w') do |f|
        f.write(to_hash.to_yaml)
      end
    end
  
    def to_s
      "\#<#{self.class}:#{object_id} @events=[0..#{events.size}]>"
    end
  
    def to_hash
      events.compact.collect {|event| event.to_hash}
    end
  
    def add_event(event)
      return unless event
      event.source = @environment
      @events << event
    end
  
    alias :env :environment
  end
end
