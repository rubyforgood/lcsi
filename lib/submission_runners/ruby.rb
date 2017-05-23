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

    delegate :run, to: :@ruby_builder

    def build
      MockResult.new
    end

    def container_user
      "root"
    end

    class MockResult
      def success?; true end
      def failure?; false end
      def out; '' end
      def err; '' end
    end
  end
end
