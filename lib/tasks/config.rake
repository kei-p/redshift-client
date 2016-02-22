require 'redshift/client'

namespace :redshift do
  task :environment do
    Rake::Task["environment"].invoke if defined?(Rails)
  end

  desc 'Output redshift db configuration'
  task config: 'redshift:environment' do
    p Redshift::Connector.default_configuration
  end
end
