require 'chef/resource/lwrp_base'

class Chef
  class Resource
    class SparkStandalone < Chef::Resource::LWRPBase
      self.resource_name = :spark_standalone
      actions :create
      default_action :create

      attribute :instance, kind_of: String, name_attribute: true
      attribute :spark_version, kind_of: String, default: '1.6.2'
      attribute :base_path, kind_of: String, default: '/usr/local/spark' # sparks will be created within this directory
      attribute :log_level, kind_of: String, default: 'INFO'
      attribute :hadoop_version, kind_of: String, default: nil
    end
  end
end
