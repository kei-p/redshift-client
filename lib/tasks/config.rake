require 'redshift/client'

namespace :redshift do
  desc 'Output redshift db configuration'
  task :config do
    p Redshift::Connector.default_configuration
  end
end
