# encoding: utf-8
require 'rake'
require 'yaml'

require 'rake/rdoctask'
require 'rspec/core/rake_task'
require 'rspec/core/version'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "roleplayer"
    gem.summary = "Add simple role support to your models."
    gem.email = "tarsolya@gmail.com"
    gem.homepage = "http://github.com/tarsolya/roleplayer"
    gem.authors = ["Tarsoly András"]
    gem.files = Dir["*", "{lib}/**/*"]
    gem.add_development_dependency 'rspec-expectations'
    gem.add_development_dependency 'rspec-mocks'
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

Rspec::Core::RakeTask.new(:spec)

task :spec => :check_dependencies

task :default => :spec

require 'rake/rdoctask'
desc 'Generate documentation for the has_roles plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'Roleplayer'
  rdoc.options << '--line-numbers' << '--inline-source' << '--format=html' << '--template=hanna'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/*.rb')
  rdoc.rdoc_files.include('app/**/*.rb')
end
