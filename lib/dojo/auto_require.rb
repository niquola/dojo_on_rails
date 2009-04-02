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
      self.response.body=body.gsub('<dojo_auto_require />',"\n<script>#{requires}\n</script>")
    end

    module ClassMethods
      def dojo_auto_require
        after_filter :dojo_auto_require
      end
    end
  end
end

