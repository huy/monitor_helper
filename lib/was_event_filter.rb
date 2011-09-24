module WAS
  class EventFilter
    def initialize(params={})
      include_expr = params[:include]
      
      if params[:exclude]
        @exclude = create_filter_block(params[:exclude])
      else
        @exclude = Proc.new {false}
      end
  
      if params[:include]
        @include = create_filter_block(params[:include])
      else
        @include = Proc.new {true}
      end
    end
  
    def satisfied?(event)
      #puts "event.event_type=#{event.event_type}, include=#{@include.call(event)}"
      not @exclude.call(event) and @include.call(event)
    end
  
    private
    
    def create_filter_block(expr)
     #puts "--- expr"
     #require 'pp'
     #pp expr
  
     filter_expr = expr.to_a.collect{|one| conjuntion_expr(one) }.join(" or ")
     #puts "--- filter expr = #{filter_expr}"
     eval "Proc.new { |event| #{filter_expr} }"
    end
  
    def conjuntion_expr(params)
      result = []
      unless (params.keys - [:event_type,:message_id,:message,:component]).empty?
        raise "only filters with :event_type,:message,:message_id are accepted"
      end
      params.each do |attr,value|
        if attr == :event_type
          result << "event.event_type=='#{value}'"
        else 
          result << "event.#{attr.to_s}=~/#{value}/mi"
        end 
  
      end
      "(#{result.join(' and ')})"
    end
  end
end
