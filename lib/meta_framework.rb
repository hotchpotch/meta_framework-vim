
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
    @root = Pathname.new(root)
  end
  attr_accessor :root

  class Buffer
    def initialize(buffer)
      @buffer = buffer
    end
    attr_reader :buffer

    def path 
      Pathname.new VIM::Function.expand("##{buffer.number}:p")
    end

    def self.current
      new VIM::Buffer.current
    end
  end
end

