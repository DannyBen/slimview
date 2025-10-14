lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'slimview/version'

Gem::Specification.new do |s|
  s.name        = 'slimview'
  s.version     = Slimview::VERSION
  s.summary     = 'Instant Slim Template Server'
  s.description = 'Command-line tool and library for quickly previewing Slim templates in a local web server'
  s.authors     = ['Danny Ben Shitrit']
  s.email       = 'db@dannyben.com'
  s.files       = Dir['README.md', 'lib/**/*.rb']
  s.executables = ['slimview']
  s.homepage    = 'https://github.com/DannyBen/slimview'
  s.license     = 'MIT'
  s.required_ruby_version = '>= 3.2'

  s.add_dependency 'slim', '~> 5.2'
  s.add_dependency 'sinatra', '~> 4.1'
  s.add_dependency 'puma', '~> 7.0'
  s.add_dependency 'rackup', '~> 2.2'

  s.metadata = {
    'bug_tracker_uri'       => 'https://github.com/dannyben/slimview/issues',
    'changelog_uri'         => 'https://github.com/dannyben/slimview/blob/master/CHANGELOG.md',
    'source_code_uri'       => 'https://github.com/dannyben/slimview',
    'rubygems_mfa_required' => 'true',
  }
end
