begin
  require 'spec'
rescue LoadError
  require 'rubygems' unless ENV['NO_RUBYGEMS']
  require 'spec'
end
begin
  require 'spec/rake/spectask'
rescue LoadError
  puts <<-EOS
To use rspec for testing you must install rspec gem:
    gem install rspec
EOS
  exit(0)
end

desc "Run the specs under spec/models"
Spec::Rake::SpecTask.new do |t|
  t.spec_opts = ['--options', "spec/spec.opts"]
  t.spec_files = FileList['spec/**/*_spec.rb']
end

namespace :spec do
  desc "Run all examples with RCov"
  Spec::Rake::SpecTask.new(:rcov) do |t|
    t.spec_files = FileList['spec/**/*_spec.rb']
    t.rcov = true
    t.rcov_opts = [
      '--exclude', 'spec'
    ]
  end

  desc "Browse the code coverage report."
  task :browse => "spec:rcov" do
    require "launchy"
    Launchy::Browser.run("coverage/index.html")
  end

  desc "Generate HTML Specdocs for all specs"
  Spec::Rake::SpecTask.new(:specdoc) do |t|
    specdoc_path = File.expand_path(File.join(File.dirname(__FILE__), '..', 'specdoc'))
    Dir.mkdir(specdoc_path) if !File.exist?(specdoc_path)

    output_file = File.join(specdoc_path, 'index.html')
    t.libs = %w[lib spec]
    t.spec_files = FileList['spec/**/*_spec.rb']
    t.spec_opts = ["--format", "\"html:#{output_file}\"", "--diff"]
    t.fail_on_error = false
  end
end
