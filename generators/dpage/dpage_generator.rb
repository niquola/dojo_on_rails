class DpageGenerator < Rails::Generator::Base
  def manifest
    record do |m|
      controller=DojoConfig.controller
      controller_file=File.join('app/controllers',"#{controller}_controller.rb")
      unless File.exists?(controller_file)
        puts "Controller [#{controller}] specified in dojo.yml not exist"
        puts "Please generate it with script/generate controller #{controller}"
        exit
      end

      views_path = File.join('app/views', controller)
      app_path = File.join(DojoConfig.root,'src',DojoConfig.application_module)
      page_path = File.join(app_path,'pages')
      css_path = File.join(app_path,'themes',DojoConfig.dojo.theme)

      m.directory views_path 
      m.directory page_path 
      m.directory css_path 

      #check defaults css and copy them if not exists
      #TODO uncomment when ready for release
      #but now this files will be changed during development
      #unless File.exists? File.join(RAILS_ROOT,css_path)
        ['common','theme_override','reset','all'].each do |css| 
          m.template "default_stylesheets/#{css}.css", File.join(css_path,"#{css}.css")
        end
      #end
      app_prefix="#{DojoConfig.application_module}.pages"
      # View template for each action.
      args.each do |action|
        
        path = File.join(views_path, "#{action}.haml")
        m.template 'view.haml', path, :assigns => { :action => action }


        app_name ="#{app_prefix}.#{action}"
        path = File.join(page_path,"#{action}.js")
        m.template 'dpage.js', path, :assigns => { :action => action , :app_name=> app_name }

        #generate separate files for different parts of mvc
        subs_dir = File.join(page_path,"#{action}")
        m.directory subs_dir

        ['models','views','controllers','autorequire'].each do |sub|
          path = File.join(subs_dir,"#{sub}.js")
          m.template "app/#{sub}.js", path, :assigns => { :action => action , :app_name=> app_name }
        end

        path = File.join(css_path,"#{action}.css")
        m.template 'dpage.css', path, :assigns => { :action => action }
      end
    end
  end
end
