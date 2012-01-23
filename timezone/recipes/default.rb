#
# Cookbook Name:: timezone 
# Recipe:: default
#
# Copyright 2012, ryuzee 
#
# MIT License 
#
## case文を使ってOSによって処理を分岐
case node[:platform]
## CentOSとAmazon Linuxの場合の処理　　　
when "centos","amazon"
  ## タイムゾーンを設定する場合の実際のコマンド
  cmd = "cp -p /usr/share/zoneinfo/Japan /etc/localtime"
  ## 指定したコマンドを実行する
  execute cmd do
    action :run
  end
end

