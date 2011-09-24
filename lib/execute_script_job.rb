require 'erb'

require File.dirname(__FILE__) +'/shell_job'
require File.dirname(__FILE__) +'/stdout'
require File.dirname(__FILE__) +'/mail'


class ExecuteScriptJob < ShellJob

  def initialize(config,params)
      params = config.merge(params)

      if params[:repeat] == -1 or params[:repeat].nil?
        params[:repeat] == 999999
      end

      script_template = File.read(params[:script_file])
      @script =  ERB.new(script_template).result(binding)
      @host = params[:host]

      super params

  end

  def action
     exec(@host,@script)
  end

end


