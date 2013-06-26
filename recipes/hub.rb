#
# Cookbook Name:: selenium
# Recipe:: selenium::hub
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
		openjdk-6-jre openjdk-6-jdk openjdk-6-source rubygems ruby-rspec-core
	}.each do |package_name|
		package "#{package_name}" do
			action :install
		end
	end
when "amazon"
	%w{
		rubygems ruby-devel git gcc automake autoconf make patch gcc-c++ readline-devel zlib-devel libyaml-devel libffi-devel openssl-devel libtool bison libxml2-devel libxslt-devel
	}.each do |package_name|
		package "#{package_name}" do
			action :install
		end
	end
end


# selenium-server の Download
remote_file "/tmp/selenium-server-standalone-2.33.0.jar" do
	source "http://selenium.googlecode.com/files/selenium-server-standalone-2.33.0.jar"
end


# gem 経由でパッケージのインストール
%w{
	selenium-webdriver selenium-client rspec	
}.each do |gem_name|
	gem_package "#{gem_name}" do
		action :install
	end
end


# サンプルコードの設置
cookbook_file "/tmp/sample.rb" do
        source "sample.rb"
        mode "0755"
end


# サンプルコードの設置
cookbook_file "/tmp/testremote" do
        source "testremote"
end


# hub の起動
script "hub" do
        interpreter "bash"
        user 'root'
        cwd '/tmp'
        code <<-EOH
                nohup java -jar /tmp/selenium-server-standalone-2.33.0.jar -role hub &
        EOH
end
