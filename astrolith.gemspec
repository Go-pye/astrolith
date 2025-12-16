Gem::Specification.new do |spec|
  spec.name          = "astrolith"
  spec.version       = "0.1.0"
  spec.authors       = ["Go-pye"]
  spec.email         = ["Go-pye@users.noreply.github.com"]

  spec.summary       = "A Ruby port of immanuel-python astrology library"
  spec.description   = "Astrolith is a decoupled astrological data calculation engine that generates structured JSON output. It supports multiple chart types including Natal, Solar Return, Progressed, Composite, and Transit charts."
  spec.homepage      = "https://github.com/Go-pye/astrolith"
  spec.license       = "MIT"

  spec.required_ruby_version = ">= 2.7.0"

  spec.files = Dir.glob("{lib,examples}/**/*") + %w[
    README.md
    LICENSE
    astrolith.gemspec
  ]

  spec.require_paths = ["lib"]

  # Core dependencies
  spec.add_dependency "swe4r", "~> 0.0.2"
  spec.add_dependency "ephemeris", "~> 0.1"
  spec.add_dependency "daru", "~> 0.3"
  spec.add_dependency "tzinfo", "~> 2.0"

  # Optional visualization dependencies
  spec.add_dependency "apexcharts", "~> 0.1"
  spec.add_dependency "prawn", "~> 2.4"

  # Development dependencies
  spec.add_development_dependency "rspec", "~> 3.12"
  spec.add_development_dependency "pry", "~> 0.14"
end
