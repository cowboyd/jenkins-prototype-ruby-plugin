require 'yaml'

class TravisScriptBuilder < Jenkins::Tasks::Builder

  display_name "Travis Builder"

  # TODO: better to use travis-worker instead of re-implementing it?
  def prebuild(build, listener)
    init(build, nil, listener)
    listener.info "Prebuild"

    travis_file = workspace + '.travis.yml'
    unless travis_file.exist?
      listener.error"Travis config `#{travis_file}' not found"
      raise "Travis config file not found"
    end
    listener.info "Found travis file: #{travis_file}"
    @config = YAML.load(travis_file.read)

    @gemfile = @config['gemfile'] || 'Gemfile'
    @gemfile = nil unless (workspace + @gemfile).exist?
    @config['script'] ||= @gemfile ? "bundle exec rake" : 'rake'

    listener.info "Prebuild finished"
  end

  def perform(build, launcher, listener)
    init(build, launcher, listener)
    listener.info "Build"

    env = setup_env
    install_dependencies
    run_scripts(env)

    listener.info "Build finished"
  end

private

  def init(build, launcher, listener)
    @build, @launcher, @listener = build, launcher, listener
  end

  def launcher
    @launcher
  end

  def listener
    @listener
  end

  def workspace
    @build.workspace
  end

  # TODO: we should have common gem repository
  def default_env
    {'BUNDLE_PATH' => '.'}
  end

  def setup_env
    env = default_env
    if @gemfile
      env['BUNDLE_GEMFILE'] = @gemfile
    end
    Array(@config['env']).each do |line|
      key, value = line.split(/\s*=\s*/, 2)
      env[key] = value
    end
    listener.info "Additional environment variable(s): #{env.inspect}"
    env
  end

  def install_dependencies
    if @gemfile
      env = default_env
      script = "bundle install"
      script += " #{@config['bundler_args']}" if @config['bundler_args']
      exec(env, script)
    end
  end

  def run_scripts(env)
    %w{before_script script after_script}.each do |type|
      next unless @config.key?(type)
      listener.info "Start #{type}: " + @config[type]
      scan_multiline_scripts(@config[type]).each do |script|
        exec(env, script)
      end
    end
  end

  def scan_multiline_scripts(script)
    case script
    when Array
      script
    else
      script.to_s.split("\n")
    end
  end

  def exec(env, command)
    listener.info "Launching command: #{command}, with environment: #{env.inspect}"
    result = launcher.execute(env, command, :chdir => workspace, :out => listener)
    listener.info "Command execution finished with #{result}"
    raise "command execution failed" if result != 0
  end
end
