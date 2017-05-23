require 'rubocop/rake_task'
require 'rspec/core/rake_task'

task ci: [:spec, :rubocop]

task :rubocop do
  RuboCop::RakeTask.new
end

RSpec::Core::RakeTask.new(:minus_docker) do |t|
  t.rspec_opts = '--tag ~type:docker'
end

task dev_specs: [:minus_docker, :rubocop]
