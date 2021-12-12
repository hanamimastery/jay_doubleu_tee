require_relative 'lib/jay_double_uti/version'

Gem::Specification.new do |spec|
  spec.name          = "jay_double_uti"
  spec.version       = JayDoubleUti::VERSION
  spec.authors       = ["Sebastian Wilgosz"]
  spec.email         = ["sebastian@hanamimastery.com"]

  spec.summary       = %q{A JWT authorization solution for any ruby web app.}
  spec.description   = %q{JayDoubleUti is a simple but powerful middleware for authorising endpoints in any ruby application. Uses dry-effects and jwt under the hood. }
  spec.homepage      = "https://github.com/hanamimastery/jay_double_uti"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/hanamimastery/jay_double_uti"
  spec.metadata["changelog_uri"] = "https://github.com/hanamimastery/jay_double_uti/tree/master/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "jwt"
  spec.add_dependency "dry-effects"
  spec.add_dependency "dry-monads"
  spec.add_dependency "dry-configurable"
end
