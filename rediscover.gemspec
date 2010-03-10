spec = Gem::Specification.new do |s|
  s.name = "rediscover"
  s.version = "0.0.2"
  s.author = "Chris Kite"
  s.homepage = "http://github.com/chriskite/rediscover"
  s.platform = Gem::Platform::RUBY
  s.summary = "Redis GUI"
  s.executables = %w[rediscover]
  s.require_path = "lib"
  s.has_rdoc = false
  s.add_dependency("wxruby", ">= 2.0.1")
  s.add_dependency("redis", ">= 0.1.2")
  s.files = Dir['lib/**/*'] + Dir['bin/*']
end
