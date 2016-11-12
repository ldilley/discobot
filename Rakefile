require 'rdoc/task'

rdoc_dir = 'rdoc'
version = '0.9.0'

RDoc::Task.new do |rdoc|
  rdoc.rdoc_dir = rdoc_dir
  rdoc.title = "DiscoBot #{version}"
  rdoc.main = 'README.doc'
  rdoc.rdoc_files.include('*.rb')
  rdoc.rdoc_files.include('modules/*.rb')
  rdoc.options << '--all'
end

task :install do
  sh 'bundle install'
end

task default: [:install]
