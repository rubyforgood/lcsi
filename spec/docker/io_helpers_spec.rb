require 'rails_helper'
require 'fileutils'
require_relative '../../lib/docker/helpers'
include Docker::Helpers

RSpec.describe 'docker file helpers', type: 'docker' do
  describe 'guaranteed file references' do
    it 'creates a file when one doesn\'t exist' do
      f = InputFile("asdf.asdf")
      expect(File.exist? f).to be_truthy
      FileUtils.rm f
      expect(File.exist? f).to be_falsey
    end

    it 'can reference existing files' do
      f = InputFile('../../README.md')
      expect(File.exist? f).to be_truthy
    end
  end
end
