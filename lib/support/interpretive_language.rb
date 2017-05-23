require_relative '../docker/helpers'
require_relative './temp_file_block'

module Support
  module InterpretiveLanguage
    def self.included(base)
      base.include Docker::Helpers
      base.include Support::TempFileBlock
    end

    def filename(io_file)
      io_file.path.rpartition('/').last
    end
    module_function :filename

    def build
      MockResult.new
    end

    def run
      temp_file_block(EntryFile(source_file), submission_dir) do |entry|
        docker_run \
          language_executable,
          filename(entry),
          chdir: submission_dir,
          in: input_buffer
      end
    end

    class MockResult
      def success?; true end
      def failure?; false end
      def out; '' end
      def err; '' end
    end
  end
end
