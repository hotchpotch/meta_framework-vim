require 'logger'

class MetaFramework
  module LoggingMock
    @@logger = Logger.new(STDOUT)
    def logger
      @@logger
    end

    def logger=(logger)
      @@logger = logger
    end

    def logging_methods(klass, *args)
      (class << klass;self end).instance_eval {
        args.each do |name|
          define_method(name) {|*options|
            LoggingMock.logger.info("call #{klass}.#{name} #{options.join(', ')}")
            options.first
          }
        end
      }
    end
    extend self

    module Vim
      LoggingMock.logging_methods self, :message, :set_option, :command, :evalulate
    end
  end
end
