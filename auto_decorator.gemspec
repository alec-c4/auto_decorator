# frozen_string_literal: true

require_relative "lib/auto_decorator/version"

Gem::Specification.new do |spec|
  spec.name = "auto_decorator"
  spec.version = AutoDecorator::VERSION
  spec.authors = ["Alexey Poimtsev"]
  spec.email = ["alexey.poimtsev@gmail.com"]

  spec.summary = "Convention-based decorator autoloading for Rails models"
  spec.description = "Automatically includes decorator modules into Rails model classes " \
                     "based on file naming convention. Zero configuration required."
  spec.homepage = "https://github.com/alec-c4/auto_decorator"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.2.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/alec-c4/auto_decorator"
  spec.metadata["changelog_uri"] = "https://github.com/alec-c4/auto_decorator/blob/main/CHANGELOG.md"
  spec.metadata["rubygems_mfa_required"] = "true"

  spec.files = Dir.chdir(__dir__) do
    Dir["{lib}/**/*", "LICENSE.txt", "README.md", "CHANGELOG.md"].reject { |f| File.directory?(f) }
  end
  spec.require_paths = ["lib"]

  spec.add_dependency "railties", ">= 7.0"

  spec.add_development_dependency "rails", ">= 7.0"
  spec.add_development_dependency "simplecov", "~> 0.21"
  spec.add_development_dependency "appraisal"
  spec.add_development_dependency "lefthook"
end
