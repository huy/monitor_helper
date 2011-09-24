require 'erb'

require File.dirname(__FILE__) +'/shell_job'
require File.dirname(__FILE__) +'/stdout'
require File.dirname(__FILE__) +'/mail'

class ProcessStatusJob < ExecuteScriptJob

  def initialize(config,params)
      params = config.merge(params)

      if params[:repeat] == -1 or params[:repeat].nil?
        params[:repeat] == 999999
      end

      script_template = File.read("erb/test_process_running.erb")
      @script =  ERB.new(script_template).result(binding)
      @host = params[:host]

      super(config,params)

     @output = create_output(params)
  end

  def create_output(params)
    klass = Object.const_get(params[:output]) if Object.const_defined?(params[:output]) 
    klass.new(params)
  end

  def action
     result = exec(@host,@script)
     
     if result.strip.empty?
        @output.send(:shells=>@shells,
            :subject_matter=>'Down',
            :config=>@config)
     end

  end

end


