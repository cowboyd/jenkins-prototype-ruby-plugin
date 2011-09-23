# TODO: move to jenkins-plugin-runtime
module Jenkins
  module Model
    class Build
      def workspace
        @native.getWorkspace().toString()
      end
    end
  end

  class Launcher
    def launch(listener = nil, &block)
      starter = @native.launch()
      starter.stdout(Jenkins::Plugin.instance.export(listener)) if listener
      starter.instance_eval(&block)
      starter.join()
    end
  end
end

require 'logger'
require 'shellwords'
require 'yaml'

class TravisScriptBuilder < Jenkins::Tasks::Builder

  display_name "Travis Builder"

  def prebuild(build, listener)
    init(build, nil, listener)
    logger.info "Prebuild"

    # TODO: Some file access methods won't work for remote build.
    # Find a way to do it even on remote host: File.exist?, File.read
    travis_file = workspace_file('.travis.yml')
    unless File.exist?(travis_file)
      logger.error"Travis config `#{travis_file}' not found"
      raise "Travis config file not found"
    end
    logger.info "Found travis file: " + travis_file
    @config = YAML.load(File.read(travis_file))

    @gemfile = @config['gemfile'] || 'Gemfile'
    @gemfile = nil unless File.exist?(workspace_file(@gemfile))
    @config['script'] ||= @gemfile ? 'bundle exec rake' : 'rake'

    logger.info "Prebuild finished"
  end

  def perform(build, launcher, listener)
    init(build, launcher, listener)
    logger.info "Build"

    setup_env

    %w{before_script script after_script}.each do |type|
      next unless @config.key?(type)
      logger.info "Start #{type}: " + @config[type]
      scan_multiline_scripts(@config[type]).each do |script|
        exec(script)
      end
    end

    logger.info "Build finished"
  end

private

  def init(build, launcher, listener)
    @build, @launcher, @listener = build, launcher, listener
    @logger = JenkinsListenerLogger.new(@listener, display_name)
  end

  def logger
    @logger
  end

  def workspace_file(file)
    File.join(@build.workspace, file)
  end

  def setup_env
    @env = {}
    if @gemfile
      @env['BUNDLE_GEMFILE'] = @gemfile
    end
    Array(@config['env']).each do |line|
      key, value = line.split(/\s*=\s*/, 2)
      @env[key] = value
    end
    logger.info "Additional environment variable(s): #{@env.inspect}"
  end

  def scan_multiline_scripts(script)
    case script
    when Array
      script
    else
      script.to_s.split("\n")
    end
  end

  # TODO: It uses Shellwords module but isn't there a easy way to do
  # 'command execution as a whole String'?
  # http://d.hatena.ne.jp/sikakura/20110324/1300977208 is doing
  # Arrays.asList(str.split(" ")) which should be wrong.
  def exec(command)
    logger.info "Launching command: #{command}"
    workspace = @build.workspace
    env = @env
    result = @launcher.launch(@listener) {
      # You cannot access @var here.
      pwd(workspace)
      envs(env)
      cmds(*Shellwords.split(command))
    }
    logger.info "Command execution finished with #{result}"
    raise "command execution failed" if result != 0
  end

  class JenkinsListenerLogger < Logger
    class JenkinsListenerIO
      def initialize(listener)
        @listener = listener
      end

      def write(msg)
        @listener.log(msg)
      end

      def close
        # do nothing for imported device
      end
    end

    def initialize(listener, progname)
      super(JenkinsListenerIO.new(listener))
      self.progname = progname
    end
  end
end
