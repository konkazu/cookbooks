#
# Cookbook Name:: subversion
# Recipe:: default
#
# Copyright 2012, ryuzee 
#
# MIT License 
#
case node[:platform]
when "centos"

  %w{subversion}.each do |package_name|
    package package_name do
      action :install
      options "--disablerepo=\\* --enablerepo=base,updates"
    end
  end
else
end
