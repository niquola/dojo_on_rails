class DijitGenerator < Rails::Generator::NamedBase
  def manifest
    record do |m|
      # Stylesheet and public directories.
      m.directory File.join('public/dojo/app')
      m.directory File.join('public/dojo/app/templates')
      m.directory File.join('public/dojo/app/themes/tundra')
      m.directory File.join('public/dojo/app/tests')
      m.template "dijit.js", "public/dojo/app/#{class_name}.js"
      m.template "dijit.html", "public/dojo/app/templates/#{class_name}.html"
      m.template "dijit.css", "public/dojo/app/themes/tundra/#{class_name}.css"
      m.template "test.html", "public/dojo/app/tests/#{class_name}Test.html"
     
      puts "Try control on url"
      puts "http://localhost:3000/dojo/app/tests/#{class_name}Test.html"
    end
  end
end

