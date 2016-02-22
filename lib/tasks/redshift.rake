require 'redshift/client'

namespace :redshift do
  desc 'redshift db configuration'
  task :config do
    p Redshift::Connector.default_configuration
  end
  #
  # # Not Supported
  # # 現状、 psqlでログインしdatabaseで手動で作成する必要あり
  # # ログイン時にパスワードを省略する方法も見つかってないため保留
  # #
  # # desc 'Creates the database config/redshift.yml for the current RAILS_ENV'
  # # task create: :config do
  # #   Rake::Task['db:create'].invoke
  # # end
  # #
  # # desc 'Drops the database from DATABASE_URL or config/redshift.yml for the current RAILS_ENV'
  # # task drop: :config do
  # #   Rake::Task['db:drop'].invoke
  # # end
  #
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
  #
  # desc 'Load the seed data from redshift/seeds.rb'
  # task seed: :config do
  #   Rake::Task['db:seed'].invoke
  # end
  #
  # desc 'Retrieves the current schema version number'
  # task version: :config do
  #   Rake::Task['db:version'].invoke
  # end
end
