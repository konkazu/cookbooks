#
# Cookbook Name:: jenkins
# Recipe:: default
#
# Copyright 2013, ryuzee 
#

case node[:platform]
when "centos", "amazon"

  package "java-1.6.0-openjdk" do
    action :install
  end

  script "install_jenkins" do
    interpreter "bash"
    cwd "/tmp"
    code <<-EOH
      sudo wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat/jenkins.repo && \
      sudo rpm --import http://pkg.jenkins-ci.org/redhat/jenkins-ci.org.key
    EOH
  end

  package "jenkins" do
    action :install
  end

  service "jenkins" do
    action :restart
  end

end
