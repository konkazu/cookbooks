#
# Cookbook Name:: capistrano
# Recipe:: default
#
# Copyright 2011, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
%w{capistrano capistrano-ext capistrano_colors}.each do |package_name|
  gem_package package_name do
    action :install
  end
end
