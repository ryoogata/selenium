#
# Cookbook Name:: selenium
# Recipe:: selenium::standalone
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
execute "apt-get update" do
  ignore_failure true
  action :nothing
end.run_action(:run) if node['platform_family'] == "ubuntu"


# 必要なパッケージのインストール
case node['platform']
when "ubuntu"
	%w{
		openjdk-6-jre openjdk-6-jdk openjdk-6-source rubygems ruby-rspec-core xvfb
	}.each do |package_name|
		package "#{package_name}" do
			action :install
		end
	end
when "centos"
	package "java" do
		action :install
	end
end


# 必要な gem package のインストール
%w{
	selenium-webdriver selenium-client rspec
}.each do |package_name|
	gem_package "#{package_name}" do
		options("--no-ri --no-rdoc")
	end
end


# selenium-server の Download
remote_file "/tmp/selenium-server-standalone-#{node['selenium']['_VERSION']}.jar" do
	source "http://selenium.googlecode.com/files/selenium-server-standalone-#{node['selenium']['_VERSION']}.jar"
end


# Xvfb の起動
script "Xvfb" do
        interpreter "bash"
        user 'root'
        code <<-EOH
                nohup /usr/bin/Xvfb :1 -screen 1 1024x768x8 &
        EOH
	environment 'DISPLAY' => ':1:1'
end


# selenum の起動
script "standalone" do
        interpreter "bash"
        user 'root'
        cwd '/tmp'
        code <<-EOH
                nohup java -jar /tmp/selenium-server-standalone-#{node['selenium']['_VERSION']}.jar &
        EOH
	environment 'DISPLAY' => ':1:1'
end
