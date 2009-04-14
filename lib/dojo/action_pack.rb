module Dojo
  module ViewHelpers
    AUTOREQUIRE_TAG="<dojo_auto_require />"
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
    def webroot
      "#{DojoConfig.webroot}/#{DojoConfig.dojo.version}"
    end
    #check if ext presented and add if not
    def add_ext(str,ext)
      ( str.strip=~/\.#{ext}$/ ) ? str.strip : "#{str.strip}.#{ext}"
    end
    def css(app_name)
      %Q[<style type="text/css">
      @import "#{webroot}/dijit/themes/#{theme}/#{add_ext(theme,'css')}";
      @import "#{webroot}/app/themes/#{theme}/widgets-all.css";
      @import "#{webroot}/app/themes/#{theme}/#{add_ext(app_name,'css')}";
      </style>]
    end
    def dojo(opts)
      %Q[
        <script type="text/javascript" src="#{webroot}/dojo/dojo.js" djConfig="#{djConf}">
        </script>
      #{autorequire}
      #{css opts[:app]}
      #{app_js opts[:app]}
      ]
    end
    def theme
      DojoConfig.dojo.theme
    end 
    def app_js(name)
      app_path="#{webroot}/app/pages/#{name}"
      %Q[
        <script type="text/javascript" src="#{app_path}.js">
        </script>
      ]
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
      self.response.body=body.gsub('<dojo_auto_require />',"\n<script>#{requires}\n</script>")
    end

    module ClassMethods
      def dojo_auto_require
        after_filter :dojo_auto_require
      end
    end
  end
end

