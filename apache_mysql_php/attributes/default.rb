default["apache"]["www_user"] = "ec2-user"
default["apache"]["www_group"] = "ec2-user"
if platform?("redhat","centos","fedora")
  default["apache"]["www_user"] = "root"
  default["apache"]["www_group"] = "root"
end
default["php"]["memory_limit"] = 128 
default["php"]["max_execution_time"] = 10
default["php"]["upload_max_filesize"] = 20
default["mysql"]["root_password"] = "password" 

default["arch"] = node['kernel']['machine'] =~ /x86_64/ ? "x86_64" : "i386"
default["php"]["remi_url"] = "http://rpms.famillecollet.com/enterprise/5/olds/#{default["arch"]}"
default["php"]["remi_url_x86_64"] = "http://rpms.famillecollet.com/enterprise/5/olds/x86_64"
