require 'shell/shell_executor'

svn_url = 'file:///I:/svn-repos/monitor'
stage_dir = 'd:/stage'

if ARGV.length < 1
    puts "example usage:\n ruby #{File.basename(__FILE__)} 0.12"
    exit(1)
end

version = ARGV[0]

tag_cmd = "svn copy . #{svn_url}/tags/#{version} -m tag"
puts "#{tag_cmd}"
system tag_cmd
exit(-1) unless $?.exitstatus==0
  
export_cmd = "svn export #{svn_url}/tags/#{version} #{stage_dir}/monitor#{version}"
puts "#{export_cmd}"
system export_cmd
exit(-1) unless $?.exitstatus==0


require 'yaml'

config = YAML.load(File.read('deploy/env.yml'))

target = ShellExecutor.new(:host=> 'machine', :passwd_file=>config[:passwd_file] , :verbose=> true)

target.upload_dir(:local_dir=>"#{stage_dir}/monitor#{version}",:remote_dir=>"/home/mon/monitor#{version}")

target.close

