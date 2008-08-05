
require 'pathname'
$LOAD_PATH.unshift Pathname.new(__FILE__).parent
$LOAD_PATH.uniq!
require 'meta_framework/vim'

class MetaFramework
  include VIM

  def self.sid=(sid)
    @@sid = sid
  end
  def self.sid
    @@sid
  end

  @@buffers = {}
  def self.registry_buffer(buffer = nil)
    buffer ||= Buffer.current
    @@buffers[buffer.number] ||= buffer
  end

  @@frameworks = {}
  def self.search(path)
    path = path.parent.realpath
    @@frameworks.each do |key, framework|
      return framework if path.to_s.index(key) == 0
    end

    count = 0
    while path.to_s != '/' || count < 20
      return new path if root? path
      count += 1
      path = path.parent
    end
    nil
  end

  def self.root?(path)
    path.join('meta_framework.yml').exist?
  end

  def initialize(root)
    @root = Pathname.new(root)
  end
  attr_accessor :root

  class Buffer
    def initialize(buffer)
      @buffer = buffer
      @framework = MetaFramework.search(path)
    end
    attr_reader :buffer

    def number
      buffer.number
    end

    def path 
      Pathname.new VIM::Function.expand("##{number}:p")
    end

    def self.current
      new VIM::Buffer.current
    end
  end
end

