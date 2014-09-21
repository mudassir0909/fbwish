# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fbwish/version'

Gem::Specification.new do |spec|
  spec.name          = "fbwish"
  spec.version       = Fbwish::VERSION
  spec.authors       = ["Mudassir Ali"]
  spec.email         = ["lime.4951@gmail.com"]
  spec.summary       = %q{Gem to automate facebook like & comment on the birthday wishes using Graph API.}
  spec.description   = ""
  spec.homepage      = "https://github.com/mudassir0909/fbwish"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_dependency "koala", "~> 1.10.1"
end
