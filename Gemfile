source :rubygems

group :development, :test do
  # Generic
  gem "bundler"
  gem "rake"
  gem "json"
  gem "bson_ext" unless RUBY_PLATFORM =~ /java/

  # Deployment
  gem "git"

  # Testing
  gem "mocha"
  gem "shoulda"
  gem "test-unit"
  gem "ci_reporter"
  gem "ruby-prof" unless RUBY_PLATFORM =~ /java/
  gem "perftools.rb" unless RUBY_PLATFORM =~ /java/

  # Java
  platforms :jruby do
    gem "bouncy-castle-java"
    gem "jruby-launcher"
    gem "jruby-openssl"
  end
end
