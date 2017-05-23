require 'rails_helper'

# TODO:
# - create fixtures directory at "spec/fixtures/submission_runners/placeholder.language_name"
# - create CompilesAndRuns, DoesntCompile, and CompilesDoesntRun fixtures

RSpec.describe SubmissionRunners::placeholder.class_name, type: :docker do
  let(:filename) { "#{problem.name}.placeholder.file_extension" }
  describe "#call" do
    let(:contest) { Contest.instance }
    let(:team)    { contest.teams.create! }
    let(:problem) do
      Problem.create_from_files!({
        contest:     contest,
        name:        problem_name,
        output_file: fixtures.join("Output"),
        input_file:  fixtures.join("Input"),
      })
    end
    let(:submission) do
      Submission.create_from_file({
        problem:  problem,
        team:     team,
        filename: fixtures.join(filename),
      }).tap(&:validate!)
    end
    let(:fixtures) { Pathname.new(Rails.root).join("spec/fixtures/submission_runners/placeholder.language_name") }

    subject(:runner) { described_class.new(submission) }

    before { runner.call }

    context "code that won't generate compiler or runtime errors" do
      let(:problem_name) { "CompilesAndRuns" }

      it "has no errors" do
        expect(runner.output_type).to eq "success"
        expect(runner.output).to_not be_nil
      end
    end

    context "code that will generate compiler errors" do
      let(:problem_name) { "DoesntCompile" }

      it "has a build failure" do
        expect(runner.output_type).to eq "build_failure"
        expect(runner.output).to_not be_nil
      end
    end

    context "code that will generate runtime errors" do
      let(:problem_name) { "CompilesDoesntRun" }

      it "has a run failure" do
        expect(runner.output_type).to eq "run_failure"
        expect(runner.output).to_not be_nil
      end
    end
  end
end
