require File.dirname(__FILE__) + '/../lib/watcher'

if ARGV.size < 1 
  puts "\n\t#{$0} <config_file1> [config_file2] ... [deploy_file1] [deploy_file2] ..."
  exit(1)
end

Watcher.new(:config_file => ARGV).watch
