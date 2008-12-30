module Dojo
  DEFAULTS={:root=>'/dojo',:debug=>true,:parse=>true,:theme=>'tundra'}
  class Builder
    def initialize buf
      @buf=buf
    end
    def require(dclass)
      @buf<< %Q[\tdojo.require("#{dclass}");]
    end
  end
  module Helper
    def dojo(opts=nil,&block)
      res=[]
      res<< dojo_base(opts) unless opts.nil?
      res<< '<script>'
      if block_given?
        b=Dojo::Builder.new(res)
        b.instance_eval &block
      end
      res<< '</script>'
      res.join "\n"
    end

    def dojo_base(opts)
      opts=Dojo::DEFAULTS.merge opts
      %Q[
        <style type="text/css">
        @import "#{opts[:root]}/dijit/themes/#{opts[:theme]}/#{opts[:theme]}.css";
        </style>
        <script type="text/javascript" src="#{opts[:root]}/dojo/dojo.js" djConfig="parseOnLoad:#{opts[:parse]}, isDebug: #{opts[:debug]}">
        </script>
      ]
    end
  end
end

