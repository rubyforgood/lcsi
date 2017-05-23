require 'rails_helper'
require_relative '../../lib/docker/helpers'
include Docker::Helpers

RSpec.describe 'OmniBuilder with Python', type: 'docker' do
  describe 'docker command and barebone python image' do
    let(:dir) { Dir.pwd + '/spec/fixtures/docker/' }

    let(:submission) {
      ->i, o, e {
        Object.new.tap { |s|
          s.define_singleton_method :id { 0 }
          s.define_singleton_method :problem_timeout { nil }
          s.define_singleton_method :source_file { e }
          s.define_singleton_method :problem_input_buffer { i }
          s.define_singleton_method :uploaded_files_dir { o.to_path.rpartition('/').first }
        }
      }
    }

    it 'good entry submission' do
      input = InputFile(File.join(dir, 'ProblemA.in'))
      output = OutputFile(File.join(dir, 'ProblemA.out'))
      good_entry = EntryFile(File.join(dir, 'good', 'ProblemA.py'))

      runner = SubmissionRunners::Python.new submission.call(input, output, good_entry)

      # # Build and Run
      # runner.build
      # r = runner.run

      # expect(r.err).to eq('')
      # expect(r.out).to eq(output.read)
      # expect(r.success?).to be_truthy

      # Call
      expect(runner.call).to be_truthy
      expect(runner.output).to eq(output.read)
      expect(runner.output_type).to eq("success")
      expect(runner.run_succeeded).to be_truthy
    end

    it 'failing entry submission' do
      input = InputFile(File.join(dir, 'ProblemA.in'))
      output = OutputFile(File.join(dir, 'ProblemA.out'))
      bad_entry = EntryFile(File.join(dir, 'bad', 'ProblemA.py'))

      runner = SubmissionRunners::Python.new submission.call(input, output, bad_entry)

      # # Build and Run
      # runner.build
      # r = runner.run

      # expect(r.err).to eq('')
      # expect(r.out).to_not eq(output.read)
      # expect(r.success?).to be_truthy

      # Call
      expect(runner.call).to be_truthy
      expect(runner.output).to_not eq(output.read)
      expect(runner.output_type).to eq("success")
      expect(runner.run_succeeded).to be_truthy
    end

    it 'invalid syntax entry submission' do
      input = InputFile(File.join(dir, 'ProblemA.in'))
      output = OutputFile(File.join(dir, 'ProblemA.out'))
      invalid_entry = EntryFile(File.join(dir, 'corrupt_code.py'))

      runner = SubmissionRunners::Ruby.new submission.call(input, output, invalid_entry)

      # Build and Run
      runner.build
      r = runner.run

      expect(r.out).to_not eq(output.read)
      expect(r.err).to_not eq('')
      expect(r.exitstatus).to_not eq(0)
      expect(r.success?).to be_falsey

      # Call
      expect(runner.call).to be_falsey
      expect(runner.output_type).to eq("run_failure")
      expect(runner.run_succeeded).to be_falsey
    end
  end
end
