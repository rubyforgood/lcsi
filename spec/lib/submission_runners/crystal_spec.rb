require 'rails_helper'
require_relative '../../../lib/docker/helpers'
include Docker::Helpers

RSpec.describe SubmissionRunners::Crystal, type: 'docker' do
  describe 'docker command and barebone Crystal image' do
    let(:dir) { Dir.pwd + '/spec/fixtures/submission_runners/crystal/' }

    before { @keep_files = Dir.entries(dir) }

    after {
      compiled = Dir.entries(dir) - @keep_files
      compiled.each do |file|
        FileUtils.rm_rf File.join(dir, file)
      end
    }

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
      good_entry = EntryFile(File.join(dir, 'compiles_and_runs.cr'))

      runner = SubmissionRunners::Crystal.new submission.call(input, output, good_entry)

      # Build
      b = runner.build

      expect(b.err).to eq('')
      expect(b.out).to_not eq(output.read)
      expect(b.success?).to be_truthy

      # Run
      r = runner.run

      expect(r.err).to eq('')
      expect(r.out).to eq(output.read)
      expect(r.success?).to be_truthy

      # Call
      runner.call
      expect(runner.output).to eq(output.read)
      expect(runner.output_type).to eq("success")
      expect(runner.run_succeeded).to be_truthy
    end

    it 'failing entry submission' do
      input = InputFile(File.join(dir, 'ProblemA.in'))
      output = OutputFile(File.join(dir, 'ProblemA.out'))
      bad_entry = EntryFile(File.join(dir, 'compiles_and_runs_wrong_answer.cr'))

      runner = SubmissionRunners::Crystal.new submission.call(input, output, bad_entry)

      # Build
      b = runner.build

      expect(b.err).to eq('')
      expect(b.out).to_not eq(output.read)
      expect(b.success?).to be_truthy

      # Run
      r = runner.run

      expect(r.err).to eq('')
      expect(r.out).to_not eq(output.read)
      expect(r.success?).to be_truthy

      # Call
      runner.call
      expect(runner.output).to_not eq(output.read)
      expect(runner.output_type).to eq("success")
      expect(runner.run_succeeded).to be_truthy
    end

    it 'compiles and doesn\'t run entry submission' do
      input = InputFile(File.join(dir, 'ProblemA.in'))
      output = OutputFile(File.join(dir, 'ProblemA.out'))
      bad_entry = EntryFile(File.join(dir, 'compiles_and_doesnt_run.cr'))

      runner = SubmissionRunners::Crystal.new submission.call(input, output, bad_entry)

      # Build
      b = runner.build

      expect(b.err).to eq('')
      expect(b.out).to_not eq(output.read)
      expect(b.success?).to be_truthy

      # Run
      r = runner.run

      expect(r.err).to_not eq('')
      expect(r.out).to_not eq(output.read)
      expect(r.success?).to be_falsey

      # Call
      runner.call
      expect(runner.output).to_not eq(output.read)
      expect(runner.output_type).to eq("run_failure")
      expect(runner.run_succeeded).to be_falsey
    end

    it 'doesn\'t compile entry submission' do
      input = InputFile(File.join(dir, 'ProblemA.in'))
      output = OutputFile(File.join(dir, 'ProblemA.out'))
      bad_entry = EntryFile(File.join(dir, 'doesnt_compile.cr'))

      runner = SubmissionRunners::Crystal.new submission.call(input, output, bad_entry)

      # Build
      b = runner.build

      expect(b.err).to_not eq('')
      expect(b.out).to_not eq(output.read)
      expect(b.success?).to be_falsey

      # Run
      r = runner.run

      expect(r.err).to_not eq('')
      expect(r.out).to_not eq(output.read)
      expect(r.success?).to be_falsey

      # Call
      runner.call
      expect(runner.output).to_not eq(output.read)
      expect(runner.output_type).to eq("build_failure")
      expect(runner.run_succeeded).to be_falsey
    end
  end
end
