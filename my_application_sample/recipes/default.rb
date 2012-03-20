#
# Cookbook Name:: my_application_sample 
# Recipe:: default
#
# Copyright 2012, ryuzee 
#
# MIT License 
#
case node[:platform]
when "centos"
  # install utterramblings 
  cmd="rpm --import http://www.jasonlitka.com/media/RPM-GPG-KEY-jlitka"
  e = execute cmd do
    action :run
  end

  template "/etc/yum.repos.d/utterramblings.repo" do
    source "utterramblings.repo.erb"
    owner "root"
    group "root"
    mode "0644"
  end

  %w{apr apr-devel gmp-devel httpd httpd-devel mod_ssl postgresql-server perl-DBD-Pg}.each do |package_name|
    package package_name do
      action :install
      options "--disablerepo=\\* --enablerepo=base,updates"
    end
  end

  %w{/etc/yum.repos.d/utterramblings.repo}.each do |file|
    e = execute "sed -e s/enabled=0/enabled=1/ ".concat(file).concat(" > /tmp/1; mv /tmp/1 ").concat(file) do
      action :run
    end
  end

  cmd="wget http://dl.fedoraproject.org/pub/epel/5/i386/memcached-1.4.5-1.el5.i386.rpm -O /tmp/memcached-1.4.5-1.el5.i386.rpm" 
  execute cmd do
    action :run
  end

  package "memcached" do
    action :install
    source "/tmp/memcached-1.4.5-1.el5.i386.rpm"
    provider Chef::Provider::Package::Rpm
  end

  service "memcached" do
    action [:enable, :start]
  end

  php_packages = {
    "php-pdo"   => {"version" => "5.2.17-jason.2"},
    "php-pgsql"   => {"version" => "5.2.17-jason.2"},
    "php-mbstring"   => {"version" => "5.2.17-jason.2"},
    "php"   => {"version" => "5.2.17-jason.2"},
    "php-cli"   => {"version" => "5.2.17-jason.2"},
    "php-ldap"   => {"version" => "5.2.17-jason.2"},
    "php-memcache"   => {"version" => "3.0.4-1.jason.1"},
    "php-common"   => {"version" => "5.2.17-jason.2"},
    "php-pear"   => {"version" => "1.9.4-1.jason.1"},
    "php-eaccelerator"   => {"version" => "0.9.6.1-jason.4"},
  }
  php_packages.each{|key, value|
    package key do
      version value["version"]
      action :install
      options "--skip-broken --disablerepo=\\* --enablerepo=utterramblings"
    end
  }

  ## update pear channel
  php_pear_channel "pear.php.net" do
    action :update
  end

  ## install pear packages
  %w{DB_DataObject Net_UserAgent_Mobile Net_Socket Net_SMTP XML_Parser Mail}.each do |pkg|
    php_pear pkg do
      action :install
    end
  end

  include_recipe "perl"

  %w{DBI Mime::Lite OLE Spreadsheet_Excel_Writer Readonly}.each do |pkg|
    cpan_module pkg do
      action :install
    end
  end

  execute "sudo chmod 777 /var/log/httpd" do
    action :run
  end

  template "/etc/logrotate.d/httpd" do
    source "httpd.erb"
    owner "root"
    group "root"
    mode "0644"
  end

  template "/etc/logrotate.d/httpd_ssl" do
    source "httpd_ssl.erb"
    owner "root"
    group "root"
    mode "0644"
  end

  service "httpd" do
    action [:enable, :start]
  end

  service "postgresql" do
    action [:enable, :start]
  end

  template "/etc/yum.repos.d/utterramblings.repo" do
    source "utterramblings.repo.erb"
    owner "root"
    group "root"
    mode "0644"
  end

else
end
