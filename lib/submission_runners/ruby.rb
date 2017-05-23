# -*- coding: utf-8 -*-
require 'submission_runners/base'

module SubmissionRunners
  class Ruby < Base
    def self.image
      'ruby:2.4.1'
    end

    def initialize(*args)
      @ruby_builder = Docker::RubyBuilder.new(self)
      super
    end

    delegate :build, :run, to: :@ruby_builder
  end
end
