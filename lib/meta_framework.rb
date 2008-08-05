
require 'pathname'
$LOAD_PATH.unshift Pathname.new(__FILE__).parent
require 'meta_framework/vim'

class MetaFramework
  include VIM

  def sid(sid)
    @@sid = sid
  end
  def sid
    @@sid
  end

  def initialize(root)
    @root = root
  end

  class Buffer
    def initialize(framework, buffer)
      @framework = framework
      @buffer = buffer
    end

    def file
    end
  end
end

