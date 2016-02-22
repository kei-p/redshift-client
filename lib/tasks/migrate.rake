require 'redshift/client'

namespace :redshift do
  desc 'Migrate the database'
  task :migrate do
    Redshift::Migrator.setup
    migrator = Redshift::Migrator.new
    migrator.migration_path = ['redshift/migrate']
    migrator.target_version = ENV['VERSION'].to_i if ENV['VERSION']
    migrator.migrate
  end
  #
  desc 'Rolls the schema back to the previous version'
  task :rollback do
    Redshift::Migrator.setup
    migrator = Redshift::Migrator.new
    migrator.migration_path = ['redshift/migrate']
    migrator.target_version = ENV['VERSION'].to_i if ENV['VERSION']
    migrator.rollback
  end
end
