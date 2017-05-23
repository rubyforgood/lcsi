require 'rails_helper'
require 'mkmf'

MakeMakefile::Logging.quiet = true
MakeMakefile::Logging.logfile(File::NULL)

RSpec.describe 'docker', type: 'docker' do
  describe 'it exists' do
    it 'docker is installed' do
      expect(MakeMakefile.find_executable('docker')).to be_truthy
    end
  end
end
