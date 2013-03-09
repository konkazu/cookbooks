#
# Cookbook Name:: apache_mysql_php
# Recipe:: default
#
# Copyright 2012, ryuzee 
#
# MIT License 
#
if node[:platform] == "centos" and node[:platform_version][0] == "5" 
  include_recipe "yum::remi"
end

case node[:platform]
when "centos","amazon"

  %w{httpd}.each do |package_name|
    package package_name do
      action :install
    end
  end

  ## register service (run level 2345 ) and restart 
  service "httpd" do
    supports :restart => true, :reload => true, :status => true
    action [:enable]
    not_if do File.exists?("/var/run/httpd.pid") end
  end

  %w{mysql-server}.each do |package_name|
    yum_package package_name do
      action :install
    end
  end

  service "mysqld" do
    action [:enable, :restart]
    supports :status => true, :start => true, :stop => true, :restart => true
    not_if do File.exists?("/var/run/mysqld/mysqld.pid") end
  end

  execute "set_mysql_root_password" do
    command "/usr/bin/mysqladmin -u root password \"#{node['mysql']['root_password']}\""
    action :run
    only_if "/usr/bin/mysql -u root -e 'show databases;'"
  end

  
  if node[:platform] == "centos" and node[:platform_version][0] == "5" 
    packages = [
      "php-5.3.19-1.el5.remi.#{node["arch"]}.rpm",
      "php-common-5.3.19-1.el5.remi.#{node["arch"]}.rpm",
      "php-cli-5.3.19-1.el5.remi.#{node["arch"]}.rpm",
      "php-devel-5.3.19-1.el5.remi.#{node["arch"]}.rpm",
      "php-mbstring-5.3.19-1.el5.remi.#{node["arch"]}.rpm",
      "php-pdo-5.3.19-1.el5.remi.#{node["arch"]}.rpm",
      "php-mysql-5.3.19-1.el5.remi.#{node["arch"]}.rpm",
      "php-xml-5.3.19-1.el5.remi.#{node["arch"]}.rpm",
    ]
    packages.each do |package_name|
      remote_file "#{Chef::Config[:file_cache_path]}/#{package_name}" do
        source  "#{node["php"]["remi_url"]}/#{package_name}" 
        action :create_if_missing
        backup false
      end
    end 

    remote_file "#{Chef::Config[:file_cache_path]}/php-pear-1.9.4-7.el5.remi.noarch.rpm" do
      source  "#{node["php"]["remi_url_x86_64"]}/php-pear-1.9.4-7.el5.remi.noarch.rpm" 
      action :create_if_missing
      backup false
    end

    e = execute "rpm -Uvh php*.rpm" do
      action :run
      cwd "#{Chef::Config[:file_cache_path]}"
      not_if do File.exists?("/usr/bin/php") end
    end
  else
    packages = %w{php php-common php-cli php-devel php-mbstring php-pdo php-mysql php-xml php-pear}
    packages.each do |package_name|
      yum_package package_name do
        action :install
      end
    end 
  end

  template "/etc/php.ini" do
    source "php.ini.erb"
    owner "root"
    group "root"
    mode "0644"
    notifies :restart, "service[httpd]"
  end

  ## if not file exists, create new one
  template "/var/www/html/index.php" do
    source "index.php.erb"
    owner node["apache"]["www_user"]
    group node["apache"]["www_group"]
    mode  "0644"
    not_if do File.exists?("/var/www/html/index.php") end
  end

end

# vim: filetype=ruby.chef
