require 'rails_helper'

RSpec.describe RunSubmissionJob, type: :job do
  let(:contest) { Contest.create! }
  let(:account)    { contest.accounts.create! }
  let(:problem) do
    Problem.create_from_files!({
      contest:     contest,
      name:        "CompilesAndRuns",
      output_file: fixtures.join("Output"),
      input_file:  fixtures.join("Input"),
    })
  end
  let(:submission) do
    Submission.create_from_file({
      problem:  problem,
      account:  account,
      filename: submission_file,
    }).tap(&:validate!)
  end
  let(:fixtures) { Pathname.new(Rails.root).join("spec/fixtures/submission_runners/java") }

  # FIXME: we still need a passing but incorrect

  context "for a correct submission" do
    let(:submission_file) { fixtures.join("CompilesAndRuns.java") }

    it 'creates a submission result' do
      RunSubmissionJob.new.perform(submission.id)

      submission.reload

      expect(submission.status).to eq "passed"
      expect(submission.reload.submission_results.count).to eq(1)

      submission_result = submission.submission_results.first

      expect(submission_result.output_type).to eq "success"
    end
  end

  context "for a build_failure submission" do
    let(:submission_file) { fixtures.join("DoesntCompile.java") }

    it 'creates a submission result' do
      RunSubmissionJob.new.perform(submission.id)

      submission.reload

      expect(submission.status).to eq "failed"
      expect(submission.reload.submission_results.count).to eq(1)

      submission_result = submission.submission_results.first

      expect(submission_result.output_type).to eq "build_failure"
    end
  end

  context "for a run_failure submission" do
    let(:submission_file) { fixtures.join("CompilesDoesntRun.java") }

    it 'creates a submission result' do
      RunSubmissionJob.new.perform(submission.id)

      submission.reload

      expect(submission.status).to eq "failed"
      expect(submission.reload.submission_results.count).to eq(1)

      submission_result = submission.submission_results.first

      expect(submission_result.output_type).to eq "run_failure"
    end
  end
end
