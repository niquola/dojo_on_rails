module Dojo
  module ViewHelpers
    DEFAULT_ADDITIONAL_CSS=['reset','override_dijit_theme']
    def djConf
      DojoConfig['djConfig'].map {|key,val| "#{key}: #{val}"}.join ','
    end
    def autorequire
      if DojoConfig['dojo']['autorequire']==true 
       params[:dojo_auto_require]=true
       "<dojo_auto_require />"
      else
       ''
      end
    end
    def webroot
      webroot=DojoConfig['dojo']['webroot']
    end
    def additional_css
      csss=(DEFAULT_ADDITIONAL_CSS + DojoConfig['dojo']['aditional_css']).uniq
      imports=csss.map do |css|
        css=add_ext css, 'css'
        ( css =~ /^\// ) ? %Q[@import "#{webroot}#{css}";] : %Q[ @import "#{webroot}/app/themes/#{theme}/#{css}";]
      end  
      imports.join "\n"
    end
    #check if ext presented and add if not
    def add_ext(str,ext)
      ( str.strip=~/\.#{ext}$/ ) ? str.strip : "#{str.strip}.#{ext}"
    end
    def css(app_name)
      %Q[<style type="text/css">
      @import "#{webroot}/dijit/themes/#{theme}/#{add_ext(theme,'css')}";
      #{additional_css}
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
      DojoConfig['dojo']['theme']
    end 
    def app_js(name)
      app_path="#{webroot}/app/pages/#{name}"
      %Q[
        <script type="text/javascript" src="#{app_path}.js">
        </script>
      ]
    end
  end
end
