# -*- coding: utf-8 -*-
require 'submission_runners/base'

module SubmissionRunners
  class Python < Base
    include Support::InterpretiveLanguage
    def self.image
      'python:3.6.1'
    end

    def language_executable
      '/usr/local/bin/python'
    end
  end
end
