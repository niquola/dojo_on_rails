require  File.join(File.dirname(__FILE__) , '../install.rb')


def load_config
  dojo_config=YAML.load_file(File.join(RAILS_ROOT,'config','dojo.yml'))
  dojo_path=File.join(RAILS_ROOT,dojo_config['dojo']['root'])
  dojo_path||=File.join(RAILS_ROOT,'public','dojo_root')
  return [dojo_path,dojo_config]
end

def build_options(config)
  config['build_opts'].map { |key, val| "#{key}=#{val}"}.join ' '
end

def build_name
 'build_'+Date.today.to_s.gsub(/[\/-]/,'_')
end

namespace :dojo do
  task :install do
    #run install from install rb
    install 'dojo_root'
  end
  task :checkout_dojo do
    #load config
    dojo_path, dojo_config= load_config 
    sc=dojo_config['vc']['name']
    action=dojo_config['vc']['action']
    #install modules
    dojo_config['vc']['modules'].each do |name,url|
      path=File.join dojo_path,'src',name
      puts "Execute: #{sc} #{action} #{url} #{path} - it could take some time - wait"
      `#{sc} #{action} #{url} #{path}`
    end
  end
  task :build do
    dojo_path, dojo_config= load_config 
    Dir.chdir File.join(dojo_path,'src','util','buildscripts') 
    profile_path=File.join(dojo_path,'profiles','standard.profile.js')
    release_dir=File.join(dojo_path,'builds')

    puts "Start building to #{release_dir}. It can take sevrak minutes. Wait. :("
    puts "./build.sh profileFile=#{profile_path} releaseDir=#{release_dir} releaseName=#{build_name} #{build_options(dojo_config)} action=release"
    `./build.sh profileFile=#{profile_path} releaseDir=#{release_dir} releaseName=#{build_name} #{build_options(dojo_config)} action=release`
  end
  task :uninstall do
    `rm -r #{RAILS_ROOT}/public/dojo_root`
    `rm  #{RAILS_ROOT}/config/dojo.yml`
  end
end

