#
# Cookbook Name:: phpunit
# Recipe:: default
#
# Copyright 2011, Ryuzee 
#
# MIT License 
#
include_recipe "php"

package "php-dom" do
  action :install
  only_if { node[:platform] == "centos" and node[:platform_version] >= "6.0" }
end

php_pear "PEAR" do
  options "--force --alldeps"
  action :upgrade
end

package "ImageMagick-devel" do
  action :install
end

channels = [
  "components.ez.no", 
  "pear.phpunit.de", 
  "pear.phpmd.org",
  "pear.symfony-project.com",
  "pear.phing.info",
  "pecl.php.net",
  "pear.pdepend.org",
  "pear.docblox-project.org",
]

channels.each do |chan|
  php_pear_channel chan do
    action :discover
  end
end

php_pear "PhpDocumentor" do
  preferred_state "stable"
  version "1.4.3"
  action :install
end

php_pear "PHP_CodeSniffer" do
  preferred_state "stable"
  version "1.3.1"
  action :install
end

php_pear "phpcpd" do
  preferred_state "stable"
  channel "phpunit"
  version "1.3.3"
  action :install
end

php_pear "PHP_PMD" do
  preferred_state "stable"
  channel "phpmd"
  version "1.2.0"
  action :install
end

# If you have encountered command timeout error, you should change the timeout value at
# /usr/lib/ruby/gems/1.8/gems/chef-0.9.14/bin/../lib/chef/shell_out.rb
# Note: At chef-10.4 you can set the value of timeout.
php_pear "PHPUnit" do
  preferred_state "stable"
  channel "phpunit"
  version "3.6.2"
  action :install
end

php_pear "phing" do
  preferred_state "alpha"
  channel "phing"
  version "2.4.8"
  action :install
end

php_pear "xdebug" do
  action :install
end

case node[:platform]
when "centos"
  template "/etc/php.d/xdebug.ini" do
    source "xdebug.ini.erb"
    owner "root"
    group "root"
    mode "0644"
  end
end

# vim: filetype=ruby.chef
