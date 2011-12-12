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

  %w{libedit}.each do |package_name|
    package package_name do
      action :install
      options "--disablerepo=\\* --enablerepo=epel"
    end
  end

  %w{httpd}.each do |package_name|
    package package_name do
      action :install
    end
  end

  php_packages = {
    "php"          => {"version" => "5.3.8-5.el5.remi.1"},
    "php-common"   => {"version" => "5.3.8-5.el5.remi.1"},
    "php-cli"      => {"version" => "5.3.8-5.el5.remi.1"},
    "php-devel"    => {"version" => "5.3.8-5.el5.remi.1"},
    "php-mbstring" => {"version" => "5.3.8-5.el5.remi.1"},
    "php-pdo"      => {"version" => "5.3.8-5.el5.remi.1"},
    "php-mysql"    => {"version" => "5.3.8-5.el5.remi.1"},
    "php-xml"      => {"version" => "5.3.8-5.el5.remi.1"},
    "php-pear"     => {"version" => "1.9.4-3.el5.remi"},
  }
  php_packages.each{|key, value|
    package key do
      version value["version"]
      action :install
      options "--skip-broken --disablerepo=\\* --enablerepo=remi"
    end
  }

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
