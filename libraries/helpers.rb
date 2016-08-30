module SparkCookbook
  module Helpers
    include Chef::DSL::IncludeRecipe

    def get_default_hadoop(spark_version)
      return '2.7' if Gem::Version.new(spark_version) >= Gem::Version.new('2.0')
      '2.6'
    end
  end
end
