# -*- coding: utf-8 -*-
require 'submission_runners/base'

module SubmissionRunners
  class placeholder.class_name < Base
    def self.image
    end

    private

    def build
      submission_dir.chmod(0777) # otherwise the nobody user doesn't have write permissions

      #docker_run
    end

    def run
      #docker_run
    end
  end
end
