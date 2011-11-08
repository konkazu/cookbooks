#
# Cookbook Name:: php5.3 From Remi
# Recipe:: default
#
# Copyright 2011, ryuzee 
#
# MIT License 
#
include_recipe "rpmrepos"

case node[:platform]
when "centos"
  # change yum settings
  %w{/etc/yum.repos.d/remi.repo /etc/yum.repos.d/epel.repo}.each do |file|
    e = execute "sed -e s/enabled=0/enabled=1/ ".concat(file).concat(" > /tmp/1; mv /tmp/1 ").concat(file) do
      action :run
    end
  end

  %w{libedit php php-common php-cli php-devel php-mbstring php-pdo php-mysql php-xml php-pear}.each do |package_name|
    package package_name do
      action :install
      options "--disablerepo=\\* --enablerepo=remi"
    end
  end

  template "/etc/php.ini" do
    source "php.ini.erb"
    owner "root"
    group "root"
    mode "0644"
  end

  service "httpd" do
    action :restart
  end

  # restore yum settings
  %w{/etc/yum.repos.d/remi.repo /etc/yum.repos.d/epel.repo}.each do |file|
    e = execute "sed -e s/enabled=1/enabled=0/ ".concat(file).concat(" > /tmp/1; mv /tmp/1 ").concat(file) do
      action :run
    end
  end

else
end
