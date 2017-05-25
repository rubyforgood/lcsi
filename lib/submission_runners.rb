module SubmissionRunners
  def self.runner_for_submission(submission)
    extension    = submission.source_file.extname
    runner_class = language_extension_map[extension]

    runner_class.new(submission)
  end

  def self.language_extension_map
    {
      '.c++'  => Cpp,
      '.cpp'  => Cpp,
      ".cc"   => Cpp,
      ".C"    => Cpp,
      ".cxx"  => Cpp,
      ".cr"   => Crystal,
      '.java' => Java,
      '.py'   => Python,
      '.rb'   => Ruby,
    }
  end
end
