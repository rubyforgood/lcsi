class SubmissionsController < ApplicationController
  def new
    @submission = Submission.new
  end

  def create
    submission = params.require :submission
    @submission = Submission.create_from_file(
        file:     submission[:attachment],
        filename: submission[:attachment].try(:original_filename),
        problem:  Problem.find_by(id: submission[:problem]),
        account:  current_account
    )

    if @submission.valid?
      RunSubmissionJob.perform_later @submission.id
      redirect_to @submission
    else
      flash.now.alert = 'Problem with submission, see below for details.'
      render 'new'
    end
  end

  def show
    @submission = Submission.find params[:id]
  end
end
