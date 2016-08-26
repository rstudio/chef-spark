# get a java.
case node['platform_family']
when 'debian'
  package 'openjdk-7-jre-headless'
when 'rhel'
  package 'java-1.7.0-openjdk'
else
  Chef::Log.warn("Not installing java, `#{node['platform_family']}' is not supported!")
end

spark_standalone 'default' # installs 1.6.3 currently. the word "default" here really doesn't mean anything.

spark_standalone '2.0.0' do # installs spark 2.0.0 with hadoop 2.7
  spark_version '2.0.0'
end
