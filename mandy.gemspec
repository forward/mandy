Gem::Specification.new do |s|
  s.specification_version = 2 if s.respond_to? :specification_version=
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=

  s.name = 'mandy'
  s.version = '0.1.0'
  s.date = '2009-07-09'

  s.description = "Map/Reduce"
  s.summary     = "Map/Reduce"

  s.authors = ["Andy Kent", "Paul Ingles"]
  s.email = "andy.kent@me.com"
  
  s.executables = %w[
    mandy-hadoop
    mandy-local
    mandy-map
    mandy-put
    mandy-reduce
  ]

  # = MANIFEST =
  s.files = %w[
    bin/mandy-hadoop
    bin/mandy-local
    bin/mandy-map
    bin/mandy-put
    bin/mandy-reduce
    readme.md
    Rakefile
    lib/mandy.rb
    lib/array_serializer.rb
    lib/dsl.rb
    lib/job.rb
    lib/mapper.rb
    lib/reducer.rb
    lib/test_runner.rb
    lib/tuple.rb
  ]
  # = MANIFEST =
  
  s.has_rdoc = false
  s.require_paths = %w[lib]
  s.rubygems_version = '1.1.1'
end
