lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'arssene/version'

Gem::Specification.new do |spec|
  spec.name          = 'arssene'
  spec.version       = Arssene::VERSION
  spec.authors       = ['Vic Carrasco']
  spec.email         = ['vic@viccarrasco.com']

  spec.summary       = 'Simple RSS solution for rails'
  spec.description   = 'Gem for retrieving entries from RSS feeds given the URL of a feed or website'
  spec.homepage      = 'https://github.com/viccarrasco/arssene'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'https://rubygems.org'

    spec.metadata['homepage_uri'] = spec.homepage
    spec.metadata['source_code_uri'] = 'https://github.com/viccarrasco/arssene'
    spec.metadata['changelog_uri'] = 'https://github.com/viccarrasco/arssene/blob/master/CHANGE_LOG.md'
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'byebug'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_dependency 'mechanize'
  spec.add_dependency 'parallel'
  spec.add_dependency 'rss'
  spec.add_dependency 'sanitize'
end
