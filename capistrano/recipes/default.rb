#
# Cookbook Name:: analog
# Recipe:: default
#
# Copyright 2013, ryuzee 
#
# MIT License 
#

# version dependency gemfile
gem_package "net-ssh" do
  action :install
  version ">=2.6.5"
end

%w{capistrano capistrano-ext capistrano_colors railsless-deploy}.each do |package_name|
  gem_package package_name do
    action :install
  end
end

# vim: filetype=ruby.chef
