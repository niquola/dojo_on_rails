module Dojo
  AUTOREQUIRE_TAG="<dojo_auto_require />"
  module ViewHelpers
    def djConf
      DojoConfig.dojo.djConfig.map {|key,val| "#{key}: #{val}"}.join ','
    end
    def autorequire
      if DojoConfig.dojo.autorequire==true 
        params[:dojo_auto_require]=true
        AUTOREQUIRE_TAG
      else
       ''
      end
    end
    def last_build_dir
        File.basename(Dir[File.join(RAILS_ROOT,DojoConfig.root,'builds','*')].max)
    end
    def webroot
      if DojoConfig.dojo.version=='last_build'
        return "#{DojoConfig.webroot}/builds/#{last_build_dir}"
      else
        return "#{DojoConfig.webroot}/#{DojoConfig.dojo.version}"
      end
    end
    #check if ext presented and add if not
    def add_ext(str,ext)
      ( str.strip=~/\.#{ext}$/ ) ? str.strip : "#{str.strip}.#{ext}"
    end
    def css(app_name)
      # http://www.webcredible.co.uk/user-friendly-resources/css/internet-explorer.shtml - we need use link not import
      %Q[<link rel="stylesheet" href="#{webroot}/app/themes/#{theme}/#{add_ext(app_name,'css')}" type="text/css" />]
    end
    def dojo(opts)
      %Q[
      <script type="text/javascript" src="#{webroot}/dojo/dojo.js" djConfig="#{djConf}"> </script>
      #{opts[:dijit_from_build].nil? ? '' : dijit_all(opts[:dijit_from_build])}
      #{autorequire}
      #{css opts[:app]}
      #{app_js opts[:app]}
      ]
    end
    #TODO: do it in a more clean way
    def dijit_all(modules)
      %Q[<script>
       dojo.registerModulePath('dijit',
       '#{DojoConfig.webroot}/builds/#{last_build_dir}/dijit');
       dojo.registerModulePath('dojo',
       '#{DojoConfig.webroot}/builds/#{last_build_dir}/dojo');
       dojo.registerModulePath('dojox',
       '#{DojoConfig.webroot}/builds/#{last_build_dir}/dojox');
       dojo.registerModulePath('debug',
       '#{DojoConfig.webroot}/builds/#{last_build_dir}/debug');
       #{modules.map{|m| "dojo.require('#{m}');"}.join("\n")}
      </script>]
    end
    def theme
      DojoConfig.dojo.theme
    end 
    def app_js(name)
      app_path="#{webroot}/app/pages/#{name}"
      %Q[<script type="text/javascript" src="#{app_path}.js"></script>]
    end
  end
  module AutoRequire
    COMP_REGEXP=Regexp.new(%q{dojoType=['"]([^"']*)['"]},true)

    def self.included(base)
      base.extend(ClassMethods)
    end

    def dojo_auto_require
      return unless params[:dojo_auto_require]
      body=self.response.body
      p body.scan(COMP_REGEXP)
      requires= body.scan(COMP_REGEXP).map{|m| %Q[dojo.require("#{m[0]}");]}.uniq.join("\n")
      self.response.body=body.gsub(AUTOREQUIRE_TAG,"\n<script>#{requires}\n</script>")
    end

    module ClassMethods
      def dojo_auto_require
        after_filter :dojo_auto_require
      end
    end
  end
end

