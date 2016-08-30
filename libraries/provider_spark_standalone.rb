require 'chef/provider/lwrp_base'
require_relative 'helpers'

class Chef
  class Provider
    class SparkStandalone < Chef::Provider::LWRPBase
      use_inline_resources if defined?(use_inline_resources)

      def whyrun_supported?
        true
      end

      # Mix in helpers from libraries/helpers.rb
      include SparkCookbook::Helpers

      action :create do
        # if user supplies hadoop version, use it explicitly. if not, case depending on spark version selected
        hadoop_version =
          if new_resource.hadoop_version.nil?
            get_default_hadoop(new_resource.spark_version)
          else
            new_resource.hadoop_version
          end
        version_name = "spark-#{new_resource.spark_version}-bin-hadoop#{hadoop_version}"
        path = ::File.join(new_resource.base_path, version_name) + '/'

        directory path do
          recursive true
        end

        remote_file "spark_standalone #{new_resource.instance}: download spark tarball" do
          path "#{Chef::Config[:file_cache_path]}/#{version_name}.tar.gz"
          source "https://d3kbcqa49mib13.cloudfront.net/#{version_name}.tgz"
          notifies :run, "bash[spark_standalone #{new_resource.instance}: extract spark tarball]", :immediately
        end

        bash "spark_standalone #{new_resource.instance}: extract spark tarball" do
          cwd Chef::Config[:file_cache_path]
          code "tar xf #{version_name}.tar.gz -C #{path} --strip-components=1"
          action :nothing
        end

        template "spark_standalone #{new_resource.instance}: create hive-site.xml" do
          cookbook 'spark'
          path "#{path}conf/hive-site.xml"
          source 'hive-site.xml.erb'
          variables(resource: new_resource)
        end

        template "spark_standalone #{new_resource.instance}: create log4j.properties" do
          cookbook 'spark'
          path "#{path}conf/log4j.properties"
          source 'log4j.properties.erb'
          variables(resource: new_resource)
        end
      end
    end
  end
end
