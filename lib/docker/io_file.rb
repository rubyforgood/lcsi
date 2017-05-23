# inherited for Input and Output classes
module Docker
  class IOFile
    def self.create(abs_path_file, source)
      raise 'Absolute path require for file' unless abs_path_file.to_s[0..0] == '/'
      dir, * = abs_path_file.rpartition('/')
      FileUtils.mkdir_p dir
      File.open(abs_path_file, 'w') { |file| file.write(source) }
      new Pathname.new(abs_path_file)
    end

    attr_reader :path, :extname, :basename, :filename
    def initialize(path)
      raise "path cannot be nil" unless path
      path = Pathname.new path
      @extname = path.extname.to_s
      @basename = path.basename(path.extname).to_s
      @filename = path.basename.to_s
      @path = path.to_s
    end
    alias :to_path :path
    alias :to_s :path

    def read
      File.open(path) { |f| f.read }
    end
  end
end
