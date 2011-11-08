#
# Cookbook Name:: chef_timeout_patch
# Recipe:: default
#
# Copyright 2011, Ryuzee 
#
# MIT License
#
case node[:platform]
  when "centos"

    source = "/usr/lib/ruby/gems/1.8/gems/chef-0.9.14/bin/../lib/chef/shell_out.rb"
    sum = "6e18b4e34c946c59797830d7cbd6b5d5"

    cmd =<<"EOS"
[[ -f #{source} ]] && [[ `md5sum #{source} | awk '{print $1}'` = #{sum} ]] && cat #{source} | sed -e "s/DEFAULT_READ_TIMEOUT = 60/DEFAULT_READ_TIMEOUT = 600/" > #{source} || true 
EOS

    e = execute cmd.chomp do
      action :run
    end
  else 
end
