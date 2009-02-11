module Dojo
  DEFAULTS={:root=>'/dojo',:debug=>true,:parse=>true,:theme=>'tundra',:auto_require=>true}
  module Helper
    def dojo(opts=nil,&block)
      res=[]
      opts=Dojo::DEFAULTS.merge opts
      res<< %Q[
        <script type="text/javascript" src="#{opts[:root]}/dojo/dojo.js" djConfig="parseOnLoad:#{opts[:parse]}, isDebug: #{opts[:debug]}">
        </script>
      ]
      if opts[:build]
        res<< %Q[<script type="text/javascript" src="#{opts[:root]}/dojo/#{opts[:build]}.js" ></script>]
      end
      if opts[:auto_require]
        params[:dojo_auto_require]=true
        #res<< "<dojo_auto_require />"
      end
      res.join "\n"
    end

    def js_builds(*args)
      args||=[]
      args.map {|source|
        %Q[<script src="#{DEFAULTS[:root]}/release/dojo/#{source.gsub(/\.js$/,'')}.js"></script>]
      }.join "\n"
    end
  
    def js(*args)
      
      args||=[]
      res=[]
      args+=['application', @controller.controller_name,"#{@controller.controller_name}/#{@controller.action_name}"]
      
      args.each {|source|
        source=source.gsub(/\.js$/,'')
        res<< %Q[<script src="/javascripts/#{source}.js"></script>] if File.exists?("#{RAILS_ROOT}/public/javascripts/#{source}.js")
      }
      res.join "\n"
    end

    def css(*args)
        args||=[]
        res=[]

        args<< "#{Dojo::DEFAULTS[:root]}/dijit/themes/#{Dojo::DEFAULTS[:theme]}/#{Dojo::DEFAULTS[:theme]}"
        args<< "#{Dojo::DEFAULTS[:root]}/app/themes/#{Dojo::DEFAULTS[:theme]}/#{Dojo::DEFAULTS[:theme]}"
        args<< '/stylesheets/application'
        args<< "/stylesheets/#{@controller.controller_name}"
        args<< "/stylesheets/#{@controller.controller_name}/#{@controller.action_name}"

        args.each {|source|
         source=source.gsub(/\.css$/,'')
         res<< %Q[<link rel="stylesheet" href="#{source}.css" type="text/css" media="screen" />] if File.exists?("#{RAILS_ROOT}/public#{source}.css")
        }
        
        res.join "\n"
    end
  end #Helper
end #Dojo
