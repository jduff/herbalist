require 'rake/testtask'
require 'rake/packagetask'
require 'rake/rdoctask'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "herbalist"
    gem.summary = %Q{Herbalist is a natural language measurements parser.}
    gem.description = %Q{Herbalist is a natural language measurements parser. It is built on top of the Alchemist[http://github.com/toastyapps/alchemist] gem and draws heavily from the Chronic[http://github.com/evaryont/chronic].}
    gem.email = "duff.john@gmail.com"
    gem.homepage = "http://github.com/jduff/herbalist"
    gem.authors = ["jduff"]
    
    gem.add_dependency('alchemist', '>= 0.1.2')
    gem.add_dependency('numerizer', '>= 0.1.1')
    
    gem.add_development_dependency('jeremymcanally-context')
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
    
    Jeweler::GemcutterTasks.new
  end
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/test_*.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end

task :test => :check_dependencies

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  if File.exist?('VERSION')
    version = File.read('VERSION')
  else
    version = ""
  end

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "herbalist #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
