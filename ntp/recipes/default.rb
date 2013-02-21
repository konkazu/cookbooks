#
# Cookbook Name:: ntp
# Recipe:: default
#
# Copyright 2013, ryuzee
#
# All rights reserved - Do Not Redistribute
#

case node[:platform]
when "centos", "amazon"
  package "ntp" do
    action :install
  end

  cmd = "/usr/sbin/ntpdate -s ntp1.jst.mfeed.ad.jp"
  e = execute cmd do
    action :run
  end

  package "crontabs" do
    action :install
  end

  cron "ntpdate" do
    user "root"
    command cmd
  end
end
