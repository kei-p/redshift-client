require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

load File.expand_path('../config/initializers/redshift.rb', __FILE__)

Dir.glob("./lib/tasks/**/*.rake").each do |file|
  load file
end

task :default => :spec
