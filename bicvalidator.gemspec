# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "bicvalidator/version"

Gem::Specification.new do |spec|
  spec.name          = "bicvalidator"
  spec.version       = Bicvalidator::VERSION
  spec.authors       = ["Olaf Kaderka"]
  spec.email         = ["okaderka@yahoo.de"]

  spec.summary       = %q{Klasse um BICS auf Konsistenz zur validieren}
  spec.description   = %q{prüft den Ländercode und die Zugehörigkeit zum SepaSchema}
  spec.homepage      = "https://github.com/olafkaderka/bicvalidator/"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib","lib/bicvalidator"]

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  #A Ruby library for testing your library against different versions of dependencie
  spec.add_development_dependency 'appraisal'

  #for mattr_accessor, reverse_merge
  spec.add_dependency "activesupport"
  
  spec.add_dependency 'activemodel'
  #laender 
  #Countries is a collection of all sorts of useful information for every country in the ISO 3166 standard. 
  #It contains info for the following standards ISO3166-1 (countries),
  #ISO3166-2 (states/subdivisions), ISO4217 (currency) and E.164 (phone numbers)
  #https://github.com/hexorx/countries
  spec.add_dependency "countries", '~> 2.1'



end
