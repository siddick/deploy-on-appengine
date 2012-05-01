require 'appengine-tools/gem_bundler'

class AppEngine::Admin::GemBundler
  def get_bundle_path
    ".gems/bundler_gems"
  end

  def bundler_envs
    "BUNDLE_WITHOUT=development:test:extra BUNDLE_PATH=#{get_bundle_path} BUNDLE_DISABLE_SHARED_GEMS=1"
  end

  def run_bundle(inst = "", system_cmd = true)
    cmd = "rvm jruby do bash -c '#{bundler_envs} bundle #{inst}'"
    output = system_cmd ? system(cmd) : `#{cmd}`
    output
  end

  def gem_bundle(args)
    get_bundle_path
    return unless args.include?('--update') || gems_out_of_date
    puts "=> Bundling gems"
    if args.include?('--update')
      run_bundle("update")
    else
      run_bundle("install")
    end
    if File.exists? app.bundled_jars
      YAML.load_file(app.bundled_jars).each do |jar|
        FileUtils.rm File.join(app.webinf_lib, jar), :force => true
      end
    end
    FileUtils.rm(app.gems_jar) rescue nil
    jars = []
    puts "=> Packaging gems"
    gem_files = Dir["#{get_bundle_path}/**/**"]
    Zip::ZipFile.open(app.gems_jar, 'w') do |jar|
      gem_files.reject {|f| f == app.gems_jar}.each do |file|
        if file[-4..-1].eql? '.jar'
          puts "=> Installing #{File.basename(file)}"
          FileUtils.cp file, app.webinf_lib
          jars << File.basename(file)
        elsif file !~ /(\.gem|cache)$/
          jar.add(file.sub(get_bundle_path, "bundler_gems"), file)
        end
      end
      bundler_lib = run_bundle("show bundler", false).strip
      Dir["#{bundler_lib}/**/**"].each{|file|
        jar.add(file.sub(bundler_lib, "bundler"), file)
      }
    end

    open(app.bundled_jars, 'w') { |f| YAML.dump(jars, f) }

  end
end
