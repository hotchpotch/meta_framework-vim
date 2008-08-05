
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

  def self.registry_current_buffer
    Buffer.current
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

  YAML_FILENAME = 'meta_framework.yml'
  def self.root?(path)
    path.join(YAML_FILENAME).exist?
  end

  def self.invoke_command_complete(arglead, cmdline, cursorpos)
    res = Buffer.current.command_complete(arglead, cmdline, cursorpos)
    VIM::command 'let g:MetaFrameworkRES=' + res.inspect
  end

  def self.invoke_command(bang, cmd, *args)
    Buffer.current.invoke(cmd, *args)
  end

  def initialize(root)
    @root = Pathname.new(root)
    @@frameworks[@root.realpath] ||= self
    @config = {
      'files' => {},
    }
    begin
      require 'yaml'
      @config.merge! YAML.load_file(@root.join(YAML_FILENAME))
    rescue Exception => e
      VIM::command("echoerr '" + e.inspect + "'")
    end
  end
  attr_accessor :root
  attr_reader :config

  class Buffer
    @@buffers = {}
    def initialize(buffer)
      @vim_buffer = buffer
      @framework = MetaFramework.search(path)
      registry_commands
    end
    attr_reader :vim_buffer

    def number
      vim_buffer.number
    end

    def path 
      Pathname.new VIM::Function.expand("##{number}:p")
    end

    def self.current
      vb = VIM::Buffer.current
      @@buffers[vb.number] ||= new vb
    end

    def invoke(*args)
    end

    def command_complete(name, cmdline, cursorpos)
      cmdname = cmdline.split(' ', 2).first
      files = @framework.config['files'][cmdname] || []
      files.map {|f| 
        Pathname.glob @framework.root.join(f.sub('{name}', "#{name}*")).to_s 
      }.flatten.map{|path| path.basename.to_s}.sort.uniq
    end

    def registry_commands
      if @framework
        sid = MetaFramework.sid
        @framework.config['files'].keys.each do |name, files|
          cmd = %Q[command! -buffer -bar -nargs=* -complete=customlist,#{sid}InvokeCommandComplete #{name} :call #{sid}InvokeCommand(<bang>0,'files',<f-args>)]
          VIM::command cmd
        end
      end
    end
  end
end

