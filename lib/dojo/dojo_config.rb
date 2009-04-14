# code is taken from git://github.com/binarylogic/settingslogic.git and adopted
module Dojo
  class Config < Hash
    class << self
      def name # :nodoc:
        instance.key?("name") ? instance.name : super
      end
      
      # Resets the singleton instance. Useful if you are changing the configuration on the fly. If you are changing the configuration on the fly you should consider creating instances.
      def reset!
        @instance = nil
      end
      
      private
        def instance
          @instance ||= new
        end
        
        def method_missing(name, *args, &block)
          instance.send(name, *args, &block)
        end
    end
    
    attr_accessor :_settings
    
    def initialize(*args) 
      case args[0]
      when Hash
        self.update args[0]
      else
        file_path = "#{RAILS_ROOT}/config/dojo.yml"
        cfg= YAML.load(ERB.new(File.read(file_path)).result).to_hash
        self.update cfg[RAILS_ENV] if defined?(RAILS_ENV)
      end
      define_settings!
    end
    
    private
      def method_missing(name, *args, &block)
        raise NoMethodError.new("no configuration was specified for #{name}")
      end
      
      def define_settings!
        self.each do |key, value|
          case value
          when Hash
            instance_eval <<-"end_eval", __FILE__, __LINE__
              def #{key}
                @#{key} ||= self.class.new(self["#{key}"])
              end
            end_eval
          else
            instance_eval <<-"end_eval", __FILE__, __LINE__
              def #{key}
                @#{key} ||= self["#{key}"]
              end
            end_eval
          end
        end
      end
  end
end
