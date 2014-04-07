#!/usr/bin/env ruby
require 'fileutils'

CONFIGFILE = "/etc/haproxy/haproxy.cfg"
TMP_CONFIGFILE = "/tmp/haproxy.cfg"

exit 0 if ENV["SERF_TAG_ROLE"] != "lb"

def member_info
  info = {}
  STDIN.each_line do |line|
    info[:node], info[:ip], info[:role], _ = line.split(' ')
  end
  info
end

info = member_info
exit 0 if info[:role] != "web"

case ENV["SERF_EVENT"]
  
when 'member-join'
  File.open(CONFIGFILE,"a") do |f|
    f.puts "    server #{info[:node]} #{info[:ip]}:80 check"
  end
  
when 'member-leave'
  target = "    server #{info[:node]} #{info[:ip]}:80 check"
  FileUtils.rm(TMP_CONFIGFILE) if File.exist?(TMP_CONFIGFILE)
  File.open(TMP_CONFIGFILE,"w") do |f|    
    File.open(CONFIGFILE,"r").each do |line|
      next if line.chomp == target
      f.write(line)
    end  
  end
  FileUtils.mv(TMP_CONFIGFILE, CONFIGFILE)
end

system("/etc/init.d/haproxy reload")
