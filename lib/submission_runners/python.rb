# -*- coding: utf-8 -*-
require 'submission_runners/base'

module SubmissionRunners
  class Python < Base
    def self.image
      'python:3.6.1'
    end

    def initialize(*args)
      @python_builder = Docker::PythonBuilder.new(self)
      super
    end

    delegate :build, :run, to: :@python_builder
  end
end
