# spark cookbook

A very basic resource for adding spark to a machine. Currently only supports standalone spark and does not attempt to manage any daemons or running spark processes.

## Supported Platforms

  * Debian/Ubuntu

## Usage

### spark_standalone resource

Include a `spark_standalone` resource in your cookbook to add the spark binary and resources to your system:

```ruby
spark_standalone 'default' do # note: resource name is not used in this resource
  # spark_version '1.6.2'
  # hadoop_version '2.6' 
  # base_path '/usr/local/spark'
  # log_level 'INFO'
end
```

Attribute details:
  
  * `spark_version` and `hadoop_version` are used directly in downloading a tarball (eg. https://d3kbcqa49mib13.cloudfront.net/spark-1.6.2-bin-hadoop2.6.tgz)
  * `hadoop_version` will default to `2.6` when a spark version < 2.0.0 is used. `2.7` otherwise.
  * `base_path` downloaded versions will be placd into this directory based on their version name.
  * `log_level` the log4j properties file will be customized to include this default log level.

The included `standalone` recipe provides some simple examples of usage, and a quick accessory to get some common sparks included.

### spark::standalone recipe

Include `spark::standalone` in your node's `run_list` to have your system configured with a java as well as spark 1.6.2 and 2.0.0:

```json
{
  "run_list": [
    "recipe[spark::standalone]"
  ]
}
```

You'll now have spark available from the locations below. set `SPARK_HOME` and give it a try.
  * `/usr/local/spark/spark-1.6.2-bin-hadoop2.6/`
  * `/usr/local/spark/spark-2.0.0-bin-hadoop2.7/`

## License and Authors

Author:: Steve Nolen (<steve.nolen@rstudio.com>)
Copyright:: 2016, RStudio Inc. 

```
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
