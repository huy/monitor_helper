require 'erb'
require File.dirname(__FILE__) +'/../shell/shell_executor'

class Mail

  def initialize(params)
    @mymail = params[:mymail] ||= 'huy.le@mydomain'
    @mail_to = params[:mail_to]
    @mail_cc = params[:mail_cc]

    @mail_body_template = params[:mail_body_template]
    @mail_subject_template = params[:mail_subject_template]

    puts "--- @mail_body_template = #{@mail_body_template}"
    puts "--- @mail_subject_template = #{@mail_subject_template}"
  end

  def send(params)
    @shell = params[:shells].values.last

    body =  ERB.new(File.read(@mail_body_template)).result(binding)
    subject =  ERB.new(File.read(@mail_subject_template)).result(binding)

    @shell.mail(:mymail=>@mymail,
                :to=>@mail_to,
                :cc=> @mail_cc,
                :subject=>subject,
                :body=>body)
  end

end

