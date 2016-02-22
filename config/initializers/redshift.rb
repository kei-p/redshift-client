require 'redshift/client'

config = YAML.load(ERB.new(File.read('config/redshift.yml')).result).deep_symbolize_keys[:test]
Redshift::Client.configuration = config
