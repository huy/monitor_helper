class Stdout
  def initialize(params)
  end

  def send(params)
    puts params[:events].collect {|e|
        "[#{e.timestamp}] #{e.source.servername} #{e.source.pid} #{e.thread_id} #{e.component} #{e.event_type} #{e.message_id}:\n#{e.message}"
      }.join("\n\n")
  end

end

