require 'ftools'


desc "install dojo"
namespace :dojo do
  task :install do
    # ruby script to set the directory.

    puts "The current directory is #{Dir.getwd}"

    Dir.chdir "#{RAILS_ROOT}/public"
    puts Dir.getwd()

    Dir.mkdir 'dojo' unless File.exists? 'dojo'
    Dir.chdir 'dojo'
    puts Dir.getwd()

    ['dojo','dijit','dojox','util'].each do |package|
      unless File.exists? package
        puts "Checkout #{package} trunk. Please wait."
        puts `svn checkout  http://svn.dojotoolkit.org/src/#{package}/trunk/ #{package}`
      end
    end
  end
end

