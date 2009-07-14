# Install hook code here
def install(dojo_root)
  puts "Create file structure"
  src_dir = File.join(File.dirname(__FILE__) ,'installation_resources','dojo_root')
  dest_dir = File.join(RAILS_ROOT,'public',dojo_root)
  FileUtils.cp_r(src_dir, dest_dir)

  puts "Copy dojo.yml to config"
  src_dir = File.join(File.dirname(__FILE__) ,'installation_resources','dojo.yml')
  dest_dir = File.join(RAILS_ROOT,'config')
  FileUtils.cp_r(src_dir, dest_dir)

  puts "Files copied - Installation complete!"
end
if __FILE__==$0
  install 'dojo_root' 
end
