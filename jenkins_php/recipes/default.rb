#
# Cookbook Name:: jenkins_php
# Recipe:: default
#
# Copyright 2013, ryuzee 
#

case node[:platform]
when "centos"

  include_recipe "jenkins"

  ## Jenkinsの起動直後に取得に失敗する場合があるが自動リトライされるので非力な環境以外は問題ない
  remote_file "/var/lib/jenkins/jenkins-cli.jar" do
    source "http://localhost:8080/jnlpJars/jenkins-cli.jar"
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
