
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

  def self.invoke_command_complete(arglead, cmdline, cursorpos)
    if buffer = @@buffers[VIM::Buffer.current.number]
      res = buffer.command_complete(arglead, cmdline, cursorpos)
    else
      res = []
    end
    VIM.command 'let g:MetaFrameworkRES=' + res.inspect
  end

  def self.invoke_command(bang, cmd, *args)
    if buffer = @@buffers[VIM::Buffer.current.number]
      buffer.invoke(cmd, *args)
    end
  end

  def initialize(root)
    @root = Pathname.new(root)
    @@frameworks[@root.realpath] ||= self
  end
  attr_accessor :root

  def command(*args)
    p args
  end

  class Buffer
    def initialize(buffer)
      @buffer = buffer
      @framework = MetaFramework.search(path)
      registry_commands
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

    def command_complete(arglead, cmdline, cursorpos)
      p [arglead, cmdline, cursorpos]
      ['aaa', 'bbb','aac']
    end

    def registry_commands
      if @framework
        sid = MetaFramework.sid
        cmd = %Q[command! -buffer -bar -nargs=* -complete=customlist,#{sid}InvokeCommandComplete META :call #{sid}InvokeCommand(<bang>0,'hello',<f-args>)]
        VIM::command cmd
        #let cplt = " -complete=custom,".s:sid.l."List"
        #exe "command! -buffer -bar -nargs=*".cplt." R".cmd.l." :call s:".l.'Edit(<bang>0,"'.cmd.'",<f-args>)'
      end
    end
  end
end

