#
# Cookbook Name:: jenkins
# Recipe:: default
#
# Copyright 2011, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

case node[:platform]
when "centos"

  package "java-1.6.0-openjdk" do
    action :install
  end

  e = execute "sudo wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat/jenkins.repo && sudo rpm --import http://pkg.jenkins-ci.org/redhat/jenkins-ci.org.key" do
    action :run
  end

  package "jenkins" do
    action :install
  end

  service "jenkins" do
    action :restart
  end

  cmd = <<"EOS"
sudo su && while [ ! `wget --retry-connrefused --tries=10 --waitretry=20 --server-response -O /var/lib/jenkins/jenkins-cli.jar http://localhost:8080/jnlpJars/jenkins-cli.jar 2>&1 | grep "200 OK"` ] ;  do wget --tries=10 --waitretry=20 -O /var/lib/jenkins/jenkins-cli.jar  http://localhost:8080/jnlpJars/jenkins-cli.jar; sleep 10; echo downloading...; done
EOS

  e = execute cmd do
    action :run
  end

  %w{checkstyle cloverphp dry htmlpublisher jdepend plot pmd violations xunit phing}.each do |plugin_name|
    e = execute "sudo /usr/bin/java -jar /var/lib/jenkins/jenkins-cli.jar -s http://localhost:8080 install-plugin ".concat(plugin_name) do
      action :run
    end
  end

  service "jenkins" do
    action :restart
  end
end
