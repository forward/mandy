Gem::Specification.new do |s|
  s.specification_version = 2 if s.respond_to? :specification_version=
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.homepage = "http://github.com/trafficbroker/mandy"

  s.name = 'mandy'
  s.version = '0.4.7'
  s.date = '2009-10-16'

  s.description = "Map/Reduce"
  s.summary     = "Map/Reduce"

  s.authors = ["Andy Kent", "Paul Ingles"]
  s.email = "andy.kent@me.com"
  
  s.add_dependency("bundler")
  
  s.executables = %w[
    mandy
    mandy-hadoop
    mandy-local
    mandy-map
    mandy-put
    mandy-get
    mandy-reduce
    mandy-rm
    mandy-mv
    mandy-exists
    mandy-install
    mandy-run
  ]

  # = MANIFEST =
  s.files = %w[
    bin/mandy-hadoop
    bin/mandy-local
    bin/mandy-map
    bin/mandy-get
    bin/mandy-put
    bin/mandy-reduce
    bin/mandy-run
    readme.md
    Rakefile
    bootstrap.rb
    Gemfile
    lib/mandy.rb
    lib/support/tuple.rb
    lib/support/formatting.rb
    lib/support/array_serializer.rb
    lib/task.rb
    lib/dsl.rb
    lib/job.rb
    lib/mappers/base_mapper.rb
    lib/mappers/transpose_mapper.rb
    lib/mappers/pass_through_mapper.rb
    lib/packer.rb
    lib/reducers/base_reducer.rb
    lib/reducers/transpose_reducer.rb
    lib/reducers/pass_through_reducer.rb
    lib/reducers/sum_reducer.rb
    lib/reducers/max_reducer.rb
    lib/reducers/min_reducer.rb
    lib/serializers/json.rb
    lib/stores/hbase.rb
    lib/stores/in_memory.rb
    lib/ruby-hbase.rb
    lib/ruby-hbase/hbase_table.rb
    lib/ruby-hbase/scanner.rb
    lib/ruby-hbase/version.rb
    lib/ruby-hbase/xml_decoder.rb
    lib/test_runner.rb
    lib/wrappers/mandy_wrapper.rb
    lib/wrappers/mandy_local_wrapper.rb
  ]
  # = MANIFEST =
  
  s.has_rdoc = false
  s.require_paths = %w[lib]
  s.rubygems_version = '1.1.1'
end
