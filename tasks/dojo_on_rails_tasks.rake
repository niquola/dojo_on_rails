require 'fileutils' 

namespace :dojo do
  namespace :install do
    desc 'copy dojo.yml to RAILS_ROOT/config'
    task :config do
      src_file = File.join(File.dirname(__FILE__) ,'../installation_resources','dojo.yml')
      dest_file = File.join(RAILS_ROOT,'config','dojo.yml')
      unless File.exists? dest_file
        FileUtils.cp(src_file, dest_file)
        puts "dojo.yml was copied to RAILS_ROOT/config dir. Change defaults and run rake dojo:install:modules"
      else
        puts "dojo.yml already installed"
      end
    end
    desc 'checkout dojo modules sources'
    task :modules=>[:config,:environment] do
      dir=File.join(DojoConfig.root,'src')
      
      unless File.exists? dir
        FileUtils.mkdir_p(dir)
      end

      Dir.chdir dir 
      DojoConfig.modules.each do |mod, opts|
        if File.exists? File.join(RAILS_ROOT, DojoConfig.root, 'src', mod)
          mode = 'update'
          Dir.chdir(File.join(RAILS_ROOT, DojoConfig.root, 'src', mod))
        else
          mode = 'checkout'
          Dir.chdir(File.join(RAILS_ROOT, DojoConfig.root, 'src'))
        end
        cmd=opts[mode]
        unless cmd.nil? || cmd.empty? 
          puts "Run #{cmd}" 
          system cmd
        end
      end
    end
    desc 'copy default application files'
    task :app do
      src_file = File.join(File.dirname(__FILE__) ,'../installation_resources','dojo.yml')
      dest_file = File.join(RAILS_ROOT,'config','dojo.yml')
      if File.exists? dest_file
        puts "File #{dest_file} already exist. Override (y/n) ?"
        agree=STDIN.gets.chomp
      end
      if agree.nil? || agree=='y'
        FileUtils.cp(src_file, dest_file)
        puts "dojo.yml was copied to RAILS_ROOT/config dir. Change defaults and run rake dojo:install:modules"
      end
    end
  end
  desc 'collect autorequire'
  task :autorequire => :environment do
    require 'action_controller/integration'
    pages_path=File.join(RAILS_ROOT, DojoConfig.root,'src',DojoConfig.application_module,'pages');
    puts pages_path
    p Dir["#{pages_path}/*.js"]
    app = ActionController::Integration::Session.new;
    app.get('/index/chart')
    puts app.html_document.root.to_s
  end
  desc 'build dojo'
  task :build => :environment do
    profile_file = File.join(RAILS_ROOT,DojoConfig.root,DojoConfig.profile)
    unless File.exists? profile_file
      puts "Profile file #{profile_file} not exists? Copy default."
      def_profile_file = File.join(File.dirname(__FILE__) ,'../installation_resources','profile.js')
      FileUtils.mkdir_p(File.dirname(profile_file))
      FileUtils.cp(def_profile_file,profile_file);
    end
    Dir.chdir File.join(RAILS_ROOT,DojoConfig.root,'src','util','buildscripts') 
    release_dir=File.join(RAILS_ROOT,DojoConfig.root,DojoConfig.release_dir)
    FileUtils.mkdir_p(release_dir) unless File.exists? release_dir
    options=DojoConfig.build_options.map { |key, val| "#{key}=#{val}"}.join ' '
    build_name='build_'+DateTime.now.to_s.gsub(/[^A-Za-z0-9_]/, '_')
    puts "Start building to #{release_dir}/#{build_name}." 
    cmd= "./build.sh profileFile=#{profile_file} releaseDir=#{release_dir} releaseName=#{build_name} #{options} action=release"
    p cmd
    system cmd
  end
end
