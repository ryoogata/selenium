#
# Cookbook Name:: selenium
# Recipe:: selenium::node
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
		openjdk-6-jre openjdk-6-jdk openjdk-6-source
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


# selenium-server の Download
remote_file "/tmp/selenium-server-standalone-2.33.0.jar" do
	source "http://selenium.googlecode.com/files/selenium-server-standalone-2.33.0.jar"
end


# node の起動
script "node" do
        interpreter "bash"
        user 'root'
        cwd '/tmp'
        code <<-EOH
                nohup java -jar /tmp/selenium-server-standalone-2.33.0.jar -role node -hub #{node['selenium']['node']['_REMOTE']} &
        EOH
	environment 'DISPLAY' => ':1'
end
