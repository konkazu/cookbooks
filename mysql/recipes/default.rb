#
# Cookbook Name:: mysql
# Recipe:: default
#
# Copyright 2011, Ryuzee
#
# MIT License
#
case node[:platform]
when "centos"
  # change yum settings
  %w{/etc/yum.repos.d/remi.repo /etc/yum.repos.d/epel.repo}.each do |file|
    e = execute "sed -e s/enabled=0/enabled=1/ ".concat(file).concat(" > /tmp/1; mv /tmp/1 ").concat(file) do
      action :run
    end
  end

  %w{mysql-server}.each do |package_name|
    yum_package package_name do
      action :install
      # for perl-DBI, I did not disable centos standard repository
      options "--enablerepo=remi,epel"
    end
  end

  service "mysqld" do
    action :restart
    supports :status => true, :start => true, :stop => true, :restart => true
  end

  # restore yum settings
  %w{/etc/yum.repos.d/remi.repo /etc/yum.repos.d/epel.repo}.each do |file|
    e = execute "sed -e s/enabled=1/enabled=0/ ".concat(file).concat(" > /tmp/1; mv /tmp/1 ").concat(file) do
      action :run
    end
  end
end

