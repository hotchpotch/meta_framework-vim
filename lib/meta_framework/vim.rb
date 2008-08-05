
class MetaFramework
  if !Kernel::const_defined?('VIM')
    require 'meta_framework/mock'
    Kernel::const_set('VIM', LoggingMock)
  end

  module ::VIM
    def escape(str)
      str.to_s.gsub("'", %q{\'})
    end
    module_function :escape
    module Function
      def method_missing(name, *args)
        args = args.map{|a| "'#{VIM::escape(a)}'" }
        VIM::evaluate("#{VIM::escape(name)}(#{args.join(', ')})")
      end

      extend self
    end
  end
end
