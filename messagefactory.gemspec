spec = Gem::Specification.new do |s|
  s.name = 'messagefactory'
  s.version = '0.0.6'
  s.has_rdoc = true
  s.extra_rdoc_files = ['README.rdoc', 'LICENSE']
  s.summary = 'Objectifies content from an IRC server'
  s.description = s.summary
  s.author = 'spox'
  s.email = 'spox@modspox.com'
  s.files = %w(LICENSE README.rdoc Rakefile) + Dir.glob("{bin,lib,spec}/**/*")
  s.require_path = "lib"
  s.bindir = "bin"
  s.required_ruby_version = '>= 1.8.7'
  s.add_dependency 'splib', '~> 1.4.3'
end
