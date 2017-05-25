# -*- coding: utf-8 -*-
require 'submission_runners/base'
require 'fileutils'
require_relative '../../lib/docker/helpers'
require_relative '../support/temp_file_block'

module SubmissionRunners
  class Crystal < Base
    attr_reader :entry
    include Docker::Helpers

    def self.image
      'crystallang/crystal:0.22.0'
    end

    def build
      FileUtils.chmod 0777, submission_dir

      @entry = EntryFile(source_file)
      docker_run('./stderr-wrapper.sh', 'crystal', 'build', '-o', entry.basename, entry.filename, chdir: submission_dir)
    end

    def run
      docker_run("./#{entry.basename}", chdir: submission_dir, in: input_buffer)
    end
  end
end
