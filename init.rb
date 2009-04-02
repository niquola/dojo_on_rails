require 'erb'
require 'yaml'
require 'dojo_on_rails'
# load config for dojo
::DojoConfig= YAML::load(ERB.new(IO.read(File.join(RAILS_ROOT,'config','dojo.yml'))).result)
