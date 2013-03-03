# vim: ft=ruby

describe 'apache_mysql_php' do
  require 'chef/mixin/shell_out'
  include Chef::Mixin::ShellOut
  include MiniTest::Chef::Assertions
  include MiniTest::Chef::Context
  include MiniTest::Chef::Resources

  it 'installs apache' do
    file('/etc/httpd/conf/httpd.conf').must_exist
  end

  it 'installs mysql' do
    file('/etc/my.cnf').must_exist
  end

  it 'installs php' do
    file('/etc/php.ini').must_exist
  end

end
