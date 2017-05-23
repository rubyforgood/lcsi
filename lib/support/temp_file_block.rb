module Support
  module TempFileBlock
    def temp_file_block(file, dir)
      Tempfile.open([file.basename, file.extname], dir) do |the_file|
        the_file.write(file.read)
        the_file.chmod(0604)
        the_file.rewind

        Dir.chdir(dir) { yield the_file }
      end
    end
    module_function :temp_file_block
  end
end
