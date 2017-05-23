require 'tty/command'

module SubmissionRunners
  class Base
    attr_reader :submission
    attr_accessor :output, :output_type, :run_succeeded

    def initialize(submission)
      @submission = submission
    end

    def call
      run_phase(:build) && run_phase(:run)
    end

    def run_succeeded?
      !!@run_succeeded
    end

    private

    def run_phase(phase)
      result = send(phase)

      if result.success?
        self.output        = result.out
        self.output_type   = "success"
        self.run_succeeded = true
      elsif result.failed?
        self.output        = result.err
        self.output_type   = "#{phase}_failure"
        self.run_succeeded = false
      end

      result.success?
    end

    def docker_run(*command, **options)
      whole_command = [
        "docker", "run",
        "--name", container,
        "--volume", "#{submission_dir}:/workspace",
        "--workdir", "/workspace",
        "--user", container_user,
        "--rm",
        "--attach", "STDIN",
        "--attach", "STDOUT",
        "--attach", "STDERR",
        "--interactive",
        self.class.image,
        *command,
      ]

      options.merge!({
        timeout: problem_timeout,
      })

      TTY::Command.
        new(printer: :null).
        run!(*whole_command, **options)
    end

    def submission_dir
      submission.uploaded_files_dir
    end

    def problem_timeout
      submission.problem_timeout || 30.seconds
    end

    def source_file
      submission.source_file
    end

    def input_buffer
      submission.problem_input_buffer
    end

    def container_user # should probably be overrideable, but this is a good default
      "nobody"
    end

    def container
      "#{self.class.name.demodulize.underscore}-#{submission.id}"
    end
  end
end
