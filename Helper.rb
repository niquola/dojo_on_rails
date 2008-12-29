module Dojo
  DEFAULTS={:root=>'/dojo/',:debug=>true,:parse=>true}
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
      b=Dojo::Builder.new(res)
      b.instance_eval &block
      res<< '</script>'
      res.join "\n"
    end
    
    def dojo_base(opts)
      opts=Dojo::DEFAULTS.merge opts
      %Q[<script src="#{opts[:root]}" dojoCfg="debug='#{opts[:debug]}';"></script>]      
    end
  end
end

class Test
  include Dojo::Helper
end

t=Test.new
res=t.dojo :root=>'droot' do
  require 'Class'
  require 'Class3'
  require 'Class2'
end
puts res

