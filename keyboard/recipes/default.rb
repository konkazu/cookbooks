#
# Cookbook Name:: keyboard
# Recipe:: default
#
# Copyright 2011, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
case node[:platform]
when "debian","ubuntu"
  template "/etc/default/console-setup" do
    source "console-setup/console-setup.erb"
    owner "root"
    group "root"
    mode "0644"
  end

  e = execute "loadkeys jp" do
    action :run
  end

when "centos"
  template "/etc/sysconfig/keyboard" do
    source "keyboard/keyboard.erb"
    owner "root"
    group "root"
    mode "0644"
  end
else
end

