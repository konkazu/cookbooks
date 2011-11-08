#
# Cookbook Name:: php
# Recipe:: default
#
# Copyright 2011, Ryuzee
#
# MIT License 
#

php_pear_channel "pear.php.net" do
  action :update
end

