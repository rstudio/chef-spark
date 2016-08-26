module SparkCookbook
  class SparkStandalone < ChefCompat::Resource
    use_automatic_resource_name
    provides :spark_standalone

    property :instance, String, name_attribute: true
    property :spark_version, String, default: '1.6.2'
    property :base_path, String, default: '/usr/local/spark' # sparks will be created within this directory
    property :log_level, String, default: 'INFO'
    property :hadoop_version, String

    ################
    # Helper Methods
    ################
    def get_default_hadoop(spark_version)
      return '2.7' if Gem::Version.new(spark_version) >= Gem::Version.new('2.0')
      '2.6'
    end

    ################
    # create method
    ################
    action :create do
      # if user supplies hadoop version, use it explicitly. if not, case depending on spark version selected
      hadoop_version = property_is_set?(:hadoop_version) ? new_resource.hadoop_version : get_default_hadoop(new_resource.spark_version)

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
