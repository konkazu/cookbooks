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

  remote_file "/etc/yum.repos.d/jenkins.repo" do
    source "http://pkg.jenkins-ci.org/redhat/jenkins.repo"
  end

  yum_key "jenkins-ci.org.key" do
    url "http://pkg.jenkins-ci.org/redhat/jenkins-ci.org.key"
    action :add
  end

  package "jenkins" do
    action :install
  end

  service "jenkins" do
    action :restart
  end

end
