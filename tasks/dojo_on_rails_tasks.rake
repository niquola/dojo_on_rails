require 'ftools'
desc "install dojo"
namespace :dojo do
  task :install do
    puts "The current directory is #{Dir.getwd}"
    Dir.chdir "#{RAILS_ROOT}/public"
    puts Dir.getwd()

    Dir.mkdir 'dojo' unless File.exists? 'dojo'
    Dir.chdir 'dojo'
    puts Dir.getwd()

    ['dojo','dijit','dojox','util'].each do |package|
      #unless File.exists? package
        puts `rm -R #{package}`
        puts "Checkout #{package} trunk. Please wait."
        puts `svn export  http://svn.dojotoolkit.org/src/#{package}/trunk/ #{package}`
      #end
    end
  end

  desc "build dojo package"
  task :build do
    #add profile generation from dojo helper and generate build for each view
    #build.sh profile=#{profile_name} action=release
    Dir.chdir "#{RAILS_ROOT}/public/dojo/util/buildscripts/"
    profile_name='app'
    puts `./build.sh profileFile=#{RAILS_ROOT}/public/dojo/app/profiles/#{profile_name}.profile.js action=release cssOptimize=comments optimize=shrinkSafe`
  end
end

