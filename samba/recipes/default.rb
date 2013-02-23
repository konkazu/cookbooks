#
# Cookbook Name:: samba 
# Recipe:: default
#
# Copyright 2012, ryuzee 
#
# MIT License 
#
# @TODO add samba user
# @TODO add shared folder
#
case node[:platform]
when "centos"

  %w{samba}.each do |package_name|
    package package_name do
      action :install
      options "--disablerepo=\\* --enablerepo=base,updates"
    end
  end

  definitions = {
    "tcp139" => {"protocol" => "tcp", "port" => 139 },
    "tcp445" => {"protocol" => "tcp", "port" => 445 },
    "udp137" => {"protocol" => "udp", "port" => 137 },
    "udp138" => {"protocol" => "udp", "port" => 138 },
  } 
  definitions.each {|key, value| 
    cmd="cat /etc/sysconfig/iptables | grep #{value["protocol"]} | grep #{value["port"]} || /sbin/iptables -I RH-Firewall-1-INPUT 1 -p #{value["protocol"]} -m #{value["protocol"]} --dport #{value["port"]} -j ACCEPT"
    execute cmd do
      action :run    
    end
  } 
  execute "/sbin/iptables-save > /etc/sysconfig/iptables" do
    action :run
  end

  service "iptables" do
    action :restart
  end

  service "smb" do
    action [:enable, :start]
  end
else
end

# vim: filetype=ruby.chef
