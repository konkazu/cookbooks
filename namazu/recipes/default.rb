#
# Cookbook Name:: namazu
# Recipe:: default
#
# Copyright 2012, ryuzee 
#
# MIT License
#

package "nkf" do
  action :install
end

kakasi_ver="2.3.4"
namazu_ver="2.0.21"

cmd="
if [ ! -f /usr/local/bin/mknmz ]; then
  wget -O /tmp/kakasi-#{kakasi_ver}.tar.gz http://kakasi.namazu.org/stable/kakasi-#{kakasi_ver}.tar.gz && 
  cd /tmp && 
  tar xvfz kakasi-#{kakasi_ver}.tar.gz && 
  cd kakasi-#{kakasi_ver} && 
  ./configure && 
  make && 
  make install && 
  wget -O /tmp/namazu-#{namazu_ver}.tar.gz http://www.namazu.org/stable/namazu-#{namazu_ver}.tar.gz && 
  cd /tmp && 
  tar xvfz namazu-#{namazu_ver}.tar.gz && 
  cd /tmp/namazu-#{namazu_ver} && 
  cd File-MMagic && 
  perl Makefile.PL && 
  make && 
  make install && 
  cd .. && 
  ./configure && 
  make && 
  make install ;
fi
"

execute cmd do
  action :run
end
