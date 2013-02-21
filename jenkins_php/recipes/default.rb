#
# Cookbook Name:: jenkins_php
# Recipe:: default
#
# Copyright 2013, ryuzee 
#

case node[:platform]
when "centos"

  cmd = <<"EOS"
    sudo su && while [ ! `wget --retry-connrefused --tries=10 --waitretry=20 --server-response -O /var/lib/jenkins/jenkins-cli.jar http://localhost:8080/jnlpJars/jenkins-cli.jar 2>&1 | grep "200 OK"` ] ;  do wget --tries=10 --waitretry=20 -O /var/lib/jenkins/jenkins-cli.jar  http://localhost:8080/jnlpJars/jenkins-cli.jar; sleep 10; echo downloading...; done
EOS

  e = execute cmd do
    action :run
  end

  cmd = <<"EOS"
  sudo wget -O default.js http://updates.jenkins-ci.org/update-center.json && sed '1d;$d' default.js > default.json && curl -X POST -H "Accept: application/json" -d @default.json http://localhost:8080/updateCenter/byId/default/postBack
EOS
  e = execute cmd do
    action :run
  end

  %w{checkstyle cloverphp dry htmlpublisher jdepend plot pmd violations xunit phing Locale}.each do |plugin_name|
    e = execute "sudo /usr/bin/java -jar /var/lib/jenkins/jenkins-cli.jar -s http://localhost:8080 install-plugin ".concat(plugin_name) do
      action :run
    end
  end

  service "jenkins" do
    action :restart
  end
end
