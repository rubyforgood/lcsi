class SubmissionRunnerGenerator < Rails::Generators::NamedBase
  source_root File.expand_path("../../submission_runner/templates", __FILE__)

  class_option :ext, type: :string, required: true, desc: 'required'

  def copy_submission_runner_template
    copy_file "submission_runner.rb", "lib/submission_runners/#{file_name}.rb"
    gsub_file "lib/submission_runners/#{file_name}.rb", 'placeholder.class_name', class_name
  end

  def copy_submission_runner_spec
    copy_file "submission_runner_spec.rb", "spec/lib/submission_runners/#{file_name}_spec.rb"
    spec_file = "spec/lib/submission_runners/#{file_name}_spec.rb"
    gsub_file spec_file, 'placeholder.class_name', class_name
    gsub_file spec_file, 'placeholder.language_name', file_name
    gsub_file spec_file, 'placeholder.file_extension', options['ext']
  end
end
