# frozen_string_literal: true

require_relative 'lib/orthoses/audited/version'

Gem::Specification.new do |spec|
  spec.name = 'orthoses-audited'
  spec.version = Orthoses::Audited::VERSION
  spec.authors = ['masatoshi_moritsuka']
  spec.email = ['yakiyaki_ikayaki@yahoo.co.jp']

  spec.summary = 'Orthoses middleware for audited'
  spec.description = 'Orthoses middleware audited'
  spec.homepage = 'https://github.com/sanfrecce-osaka/orthoses-audited'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 3.2.0'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['changelog_uri'] = spec.homepage
  spec.metadata['rubygems_mfa_required'] = 'true'

  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ Gemfile .gitignore .rspec spec/])
    end
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'audited'
  spec.add_dependency 'orthoses'
end
