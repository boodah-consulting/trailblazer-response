# Generated by juwelier
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Juwelier::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-
# stub: trailblazer-response 0.0.1 ruby lib

require "./lib/trailblazer/response/version"

Gem::Specification.new do |s|
  s.name = "trailblazer-response".freeze
  s.version = Trailblazer::Response::VERSION

  s.require_paths = ["lib".freeze]
  s.authors = ["Yomi Colledge".freeze]
  s.date = "2021-06-09"
  s.description = "Standardising Trailblazer::Operation results".freeze
  s.summary = "Standardising Trailblazer::Operation results".freeze
  s.email = "baphled@boodah.net".freeze
  s.extra_rdoc_files = [
    "LICENSE",
    "README.md"
  ]
  s.files = [
    ".document",
    ".releaserc",
    ".ruby-gemset",
    ".ruby-version",
    ".travis.yml",
    "Gemfile",
    "Gemfile.lock",
    "LICENSE",
    "LICENSE.txt",
    "README.md",
    "Rakefile",
    "lib/trailblazer-response.rb",
    "lib/trailblazer/response.rb",
    "lib/trailblazer/**/**.rb",
    "package-lock.json",
    "package.json",
  ]
  s.homepage = "http://github.com/baphled/trailblazer-response".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "3.2.3".freeze
  s.summary = "A standardised way of handling Trailblazer::Operation results".freeze

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_runtime_dependency(%q<trailblazer>.freeze, [">= 2.1.0"])
    s.add_runtime_dependency(%q<activesupport>.freeze, [">= 6.1.3.2"])
    s.add_runtime_dependency(%q<activemodel>.freeze, [">= 6.1.3.2"])
    s.add_runtime_dependency(%q<active_model_serializers>.freeze, ["~> 0.10.0"])
    s.add_development_dependency(%q<pry>.freeze, [">= 0.14.1"])
    s.add_development_dependency(%q<bundler>.freeze, ["= 2.2.19"])
    s.add_development_dependency(%q<json>.freeze, [">= 2.3.0"])
    s.add_development_dependency(%q<rspec>.freeze, [">= 3.10.0"])
    s.add_development_dependency(%q<juwelier>.freeze, ["~> 2.4.9"])
    s.add_development_dependency(%q<simplecov>.freeze, [">= 0.21.2"])
  else
    s.add_dependency(%q<trailblazer>.freeze, [">= 2.1.0"])
    s.add_dependency(%q<activesupport>.freeze, [">= 6.1.3.2"])
    s.add_dependency(%q<activemodel>.freeze, [">= 6.1.3.2"])
    s.add_dependency(%q<active_model_serializers>.freeze, ["~> 0.10.0"])
    s.add_dependency(%q<pry>.freeze, [">= 0.14.1"])
    s.add_dependency(%q<bundler>.freeze, ["= 2.2.19"])
    s.add_dependency(%q<json>.freeze, [">= 2.3.0"])
    s.add_dependency(%q<rspec>.freeze, [">= 3.10.0"])
    s.add_dependency(%q<juwelier>.freeze, ["~> 2.4.9"])
    s.add_dependency(%q<simplecov>.freeze, [">= 0.21.2"])
  end
end
