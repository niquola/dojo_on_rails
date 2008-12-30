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

    puts "Checkout dojo trunk. Please wait."
    puts `svn checkout  http://svn.dojotoolkit.org/src/dojo/trunk/ dojo`
    puts "Checkout dijit trunk. Please wait."
    puts `svn checkout  http://svn.dojotoolkit.org/src/dijit/trunk/ dijit`
    puts "Checkout dojox trunk. Please wait."
    puts `svn checkout  http://svn.dojotoolkit.org/src/dojox/trunk/ dojox`
    puts "Checkout util trunk. Please wait."
    puts `svn checkout  http://svn.dojotoolkit.org/src/util/trunk/ util`

  end
end

