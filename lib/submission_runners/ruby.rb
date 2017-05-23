# -*- coding: utf-8 -*-
require 'submission_runners/base'

module SubmissionRunners
  class Ruby < Base
    include Support::InterpretiveLanguage
    def self.image
      'ruby:2.4.1'
    end

    def language_executable
      '/usr/local/bin/ruby'
    end
  end
end
