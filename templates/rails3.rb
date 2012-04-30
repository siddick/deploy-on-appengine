gsub_file   'Gemfile', /https:/, "http:"
append_file 'Gemfile', <<-Gemfile
platform :jruby do
  gem 'jruby-openssl'
  gem 'appengine-rack'
  gem 'appengine-apis'
  gem 'activerecord-jdbcmysql-adapter'
end

group :extra do
  gem 'deploy-on-appengine', :path => '/home/siddick/project/appengine/deploy-on-appengine/'
end
Gemfile

append_file 'config/database.yml', <<-Database
<% if defined? JRuby %>
production:
  adapter: mysql
  driver: com.google.appengine.api.rdbms.AppEngineDriver
  url: jdbc:google:rdbms://username:username/dbname
<% end %>
Database

gsub_file 'config.ru', /^.*require ::File.*$/ do |content| <<-ConfigRu
if defined? JRuby
  ENV['BUNDLE_WITHOUT'] = 'development:test:extra'
  ENV['BUNDLE_PATH'] = ENV['GEM_PATH'] = 'file:WEB-INF/lib/gems.jar!/.gems/bundler'
  ENV['BUNDLE_DISABLE_SHARED_GEMS'] = '1'
  $LOAD_PATH.push(ENV['GEM_PATH'] + "/bundler/lib")
  require 'rubygems'
  require 'deploy-on-appengine/ruby_patch'
end
#{content}
ConfigRu
end
