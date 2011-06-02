Gem::Specification.new do |s|
  s.specification_version = 2 if s.respond_to? :specification_version=
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.homepage = "http://github.com/forward/mandy"

  s.name = 'mandy'
  s.version = File.read(File.join(File.dirname(__FILE__),'VERSION'))
  s.date = "#{Time.now.strftime('%Y-%m-%e')}"

  s.description = "Mandy is Ruby Map/Reduce Framework built onto of the Hadoop Distributed computing platform."
  s.summary     = "Map/Reduce Framework"

  s.authors = ["Andy Kent", "Paul Ingles"]
  s.email = "andy.kent@me.com"
  
  s.add_dependency("json")

  s.executables = %w[
    mandy
    mandy-kill
    mandy-hadoop
    mandy-hdfs
    mandy-local
    mandy-map
    mandy-put
    mandy-get
    mandy-cat
    mandy-reduce
    mandy-rm
    mandy-mv
    mandy-cp
    mandy-mkdir
    mandy-exists
    mandy-install
    mandy-lsr
  ]

  # = MANIFEST =
  s.files = %w[
    bin/mandy
    bin/mandy-hadoop
    bin/mandy-local
    bin/mandy-kill
    bin/mandy-map
    bin/mandy-put
    bin/mandy-get
    bin/mandy-cat
    bin/mandy-reduce
    bin/mandy-rm
    bin/mandy-mv
    bin/mandy-cp
    bin/mandy-mkdir
    bin/mandy-exists
    bin/mandy-install
    bin/mandy-lsr
    VERSION
    readme.md
    Rakefile
    bootstrap.rb
    geminstaller.yml
    lib/mandy.rb
    lib/mandy/errors.rb
    lib/mandy/configuration/hadoop_configuration.rb
    lib/mandy/support/tuple.rb
    lib/mandy/support/formatting.rb
    lib/mandy/support/array_serializer.rb
    lib/mandy/support/hdfs_location.rb
    lib/mandy/task.rb
    lib/mandy/dsl.rb
    lib/mandy/job.rb
    lib/mandy/mappers/base_mapper.rb
    lib/mandy/mappers/transpose_mapper.rb
    lib/mandy/mappers/pass_through_mapper.rb
    lib/mandy/packer.rb
    lib/mandy/reducers/base_reducer.rb
    lib/mandy/reducers/transpose_reducer.rb
    lib/mandy/reducers/pass_through_reducer.rb
    lib/mandy/reducers/sum_reducer.rb
    lib/mandy/reducers/max_reducer.rb
    lib/mandy/reducers/min_reducer.rb
    lib/mandy/serializers/json.rb
    lib/mandy/stores/hbase.rb
    lib/mandy/stores/in_memory.rb
    lib/mandy/ruby-hbase.rb
    lib/mandy/ruby-hbase/hbase_table.rb
    lib/mandy/ruby-hbase/scanner.rb
    lib/mandy/ruby-hbase/version.rb
    lib/mandy/ruby-hbase/xml_decoder.rb
    lib/mandy/test_runner.rb
  ]
  # = MANIFEST =
  
  s.has_rdoc = false
  s.require_paths = %w[lib]
  s.rubygems_version = '1.1.1'
end
