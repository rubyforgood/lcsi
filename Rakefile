# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative 'config/application'

Rails.application.load_tasks

desc 'Pull Docker Images'
task :docker do
  require_relative 'lib/submission_runners'
  require 'set'
  Dir['lib/submission_runners/*'].each do |f| require_relative f end
  include SubmissionRunners
  Set.new(SubmissionRunners.language_extension_map.values).each do |language|
    system(*%W[docker pull #{language.image}])
  end
end
