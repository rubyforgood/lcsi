require 'rails_helper'
require_relative '../support/docker/ruby'
include Support::Docker::Ruby

RSpec.describe 'OmniRunner with Ruby', type: :docker do
  describe 'It works with docker command and barebone ruby image' do
    it 'the big picture result here' do
      Dir.mktmpdir { |dir|
        Dir.chdir(dir) {
          input = Docker::Input.create(File.join(dir, 'ProblemA.in'), in_file)
          output = Docker::Output.create(File.join(dir, 'ProblemA.out'), out_file)
          good_entry = Docker::Entry.create(File.join(dir, 'ProblemA.rb'), good_entry_file)
          bad_entry = Docker::Entry.create(File.join(dir, 'ProblemB.rb'), bad_entry_file)

          expect(File.exist? input.path).to be_truthy
          expect(File.exist? output.path).to be_truthy
          expect(File.exist? good_entry.path).to be_truthy
          expect(File.exist? bad_entry.path).to be_truthy

          runner = Docker::RubyRunner.new(dir)

          sys_exec(runner.run(good_entry, input, output))
          expect(out).to eq('')
          expect(err).to eq('')
          expect(@exitstatus).to eq(0)

          sys_exec(runner.run(bad_entry, input, output))
          expect(out).to_not eq('')
          expect(err).to eq('')
          expect(@exitstatus).to_not eq(0)
        }
      }
    end
  end
end