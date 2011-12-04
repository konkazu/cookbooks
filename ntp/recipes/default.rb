#
# Cookbook Name:: ntp
# Recipe:: default
#
# Copyright 2011, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
package "ntp" do
  action :install
end

cmd = "/usr/sbin/ntpdate -s ntp1.jst.mfeed.ad.jp"
e = execute cmd do
  action :run
end

cron "ntpdate" do
  user "root"
  command cmd
end
