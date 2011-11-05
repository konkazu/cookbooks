#
# Cookbook Name:: php5.3 
# Recipe:: default
#
# Copyright 2011, ryuzee 
#
# MIT License 
#
case node[:platform]
when "centos"
  %w{php53 php53-common php53-cli php53-mbstring php53-mcrypt php53-pdo php53-mysql php53-xml}.each do |package_name|
    package package_name do
      action :install
      options "--enablerepo=remi,epel"
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
else
end
