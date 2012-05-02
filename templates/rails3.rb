gsub_file   'Gemfile', /https:/, "http:"
gsub_file   'Gemfile', /sqlite3.*$/, '\0, :platforms => :ruby'
append_file 'Gemfile', <<-Gemfile
platform :jruby do
  gem 'jruby-openssl'
  gem 'appengine-rack'
  gem 'appengine-apis'
  gem 'activerecord-jdbcmysql-adapter'
end
Gemfile

append_file 'config/database.yml', <<-Database

<% if defined? JRuby %>
appengine:
  adapter: mysql
  driver: com.google.appengine.api.rdbms.AppEngineDriver
  url: jdbc:google:rdbms://username:username/dbname
<% end %>
Database

gsub_file 'config.ru', /^.*require ::File.*$/ do |content| <<-ConfigRu
if defined? JRuby
  ENV['BUNDLE_WITHOUT'] = 'development:test:extra'
  ENV['BUNDLE_PATH'] = 'file:WEB-INF/lib/gems.jar!/bundler_gems'
  ENV['BUNDLE_DISABLE_SHARED_GEMS'] = '1'
  ENV['RAILS_ENV'] = 'appengine'
  $LOAD_PATH.push("file:WEB-INF/lib/gems.jar!/bundler/lib")

  load File.expand_path("../lib/jruby_patch.rb", __FILE__)
end
#{content}
ConfigRu
end

create_file "config/environments/appengine.rb", File.read("config/environments/production.rb")
gsub_file   "config/environments/appengine.rb", /Application.configure do/ do |content|
<<-EnvConfig
#{content}

  require 'appengine-apis/logger'
  config.logger = AppEngine::Logger.new
EnvConfig
end

# run("gem install deploy-on-appengine")

create_file "lib/jruby_patch.rb", <<-RubyPatch
class File
  class << self
    alias :_org_join :join
    def join(*args)
      _org_join(*args).sub(/^.*file:/, 'file:')
    end

    alias :_org_mtime :mtime
    def mtime(file)
      file =~ /^file:/ ? Time.at(0) : _org_mtime(file)
    end
  end
end
RubyPatch


run("appcfg generate_app .")
