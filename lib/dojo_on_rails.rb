require 'active_support'
module Dojo
  class << self
    def enable
      enable_actionpack
    end
    def enable_actionpack
      return if ActionView::Base.instance_methods.include? 'dojo'
      require 'dojo/action_pack'
      ActionView::Base.send :include, ViewHelpers
      if defined?(ActionController::Base) 
        ActionController::Base.send :include, AutoRequire
        ActionController::Base.send :after_filter, :dojo_auto_require
      end
    end
  end
end
if defined?(Rails) and defined?(ActiveRecord) and defined?(ActionController)
  Dojo.enable
end

