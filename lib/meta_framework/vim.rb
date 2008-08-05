
class MetaFramework
  if !Kernel::const_defined?('VIM')
    require 'meta_framework/mock'
    Kernel::const_set('VIM', LoggingMock)
  end

  module ::VIM
    def escape(str)
      str.gsub("'", %q{'\''})
    end
    module_function :escape
    class Method
      def self.method_missing(name, *args)
        args = args.map{|a| "'#{escape(a)}'" }
        VIM::evaluate("#{escape(name)}(#{args.join(', ')})")
      end
    end
  end
end
