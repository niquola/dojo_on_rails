module Dojo
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
      #body.split("\n").each do |line|
        #match=COMP_REGEXP.match(line)
        #components<< match[1] unless match.nil? || match[1].nil?
      #end
      #requires=components.uniq.map{|comp| %Q[dojo.require("#{comp}");]}
      theme=params[:dojo_theme]||Dojo::DEFAULTS[:theme]
      self.response.body=body.gsub('<dojo_auto_require />',"\n<script>#{requires}\n</script>")
    end

    module ClassMethods
      def dojo_auto_require
        after_filter :dojo_auto_require
      end
    end
  end
end

