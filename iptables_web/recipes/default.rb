#
# Cookbook Name:: iptables_web
# Recipe:: default
#
# Copyright 2011, Ryuzee
#
# MIT License 
#
case node[:platform]
when "centos"
  template "/etc/sysconfig/iptables" do
    source "iptables.erb"
    owner "root"
    group "root"
    mode "0644"
  end

  service "iptables" do
    action :restart
  end
end
