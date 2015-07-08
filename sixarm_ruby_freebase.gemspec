# -*- coding: utf-8 -*-

Gem::Specification.new do |s|

  s.name              = "sixarm_ruby_freebase"
  s.summary           = "SixArm.com » Ruby » Freebase client"
  s.description       = "Freebase client for simple mqlread access"
  s.version           = "1.0.10"

  s.author            = "SixArm"
  s.email             = "sixarm@sixarm.com"
  s.homepage          = "http://sixarm.com/"
  s.licenses          = ["BSD", "GPL", "MIT", "PAL", "Various"]

  s.signing_key       = "/opt/keys/sixarm/sixarm-rsa-4096-x509-20150314-private.pem"
  s.cert_chain        = ["/opt/keys/sixarm/sixarm-rsa-4096-x509-20150314-public.pem"]

  s.platform          = Gem::Platform::RUBY
  s.require_path      = "lib"
  s.has_rdoc          = true

  s.files = [
    ".gemtest",
    "CHANGES.md",
    "LICENSE.md",
    "Rakefile",
    "README.md",
    "VERSION",
    "lib/sixarm_ruby_freebase.rb",
  ]

  s.test_files = [
    "test/sixarm_ruby_freebase_test.rb",
  ]

  s.add_dependency('json_pure', '>= 1.8.2', '< 2')

end
