#
# Cookbook Name:: utterramblings 
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

  %w{apr apr-devel gmp-devel httpd httpd-devel mod_ssl postgresql-server}.each do |package_name|
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

  service "httpd" do
    action [:enable, :restart]
  end

  template "/etc/yum.repos.d/utterramblings.repo" do
    source "utterramblings.repo.erb"
    owner "root"
    group "root"
    mode "0644"
  end

else
end
