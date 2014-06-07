lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "jdoc/version"

Gem::Specification.new do |spec|
  spec.name          = "jdoc"
  spec.version       = Jdoc::VERSION
  spec.authors       = ["Ryo Nakamura"]
  spec.email         = ["r7kamura@gmail.com"]
  spec.summary       = "Generate API documentation from JSON Schema."
  spec.homepage      = "https://github.com/r7kamura/jdoc"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "rack-spec", ">= 0.1.7"
  spec.add_development_dependency "activesupport"
  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "erubis"
  spec.add_development_dependency "json_schema"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "2.14.1"
end
