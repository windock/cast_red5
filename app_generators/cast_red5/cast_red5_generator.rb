class CastRed5Generator < RubiGen::Base

  DEFAULT_SHEBANG = File.join(Config::CONFIG['bindir'],
                              Config::CONFIG['ruby_install_name'])

  default_options :author => nil

  attr_reader :name
  attr_reader :package

  def initialize(runtime_args, runtime_options = {})
    super
    usage if args.empty?
    @package = args.shift
    @destination_root = File.expand_path(@package.split(".").last)
    @name = base_name
    extract_options
  end

  def manifest
    record do |m|
      m.directory ''
      BASEDIRS.each { |path| m.directory path }

      m.template_copy_each %w( build.properties
                               build.xml
                               www/WEB-INF/red5-web.properties
                               www/WEB-INF/red5-web.xml
                               www/WEB-INF/web.xml )

      m.template  "src/logback-name.xml", "src/logback-#{name}.xml"

      src_path = "src/" + @package.gsub(".", "/")
      m.directory src_path
      m.template  "src/Application.java", "#{src_path}/Application.java"
    end
  end

  protected
    def banner
      <<-EOS
Creates a basic red5 application

USAGE: #{spec.name} [package_name]
EOS
    end

    def add_options!(opts)
      opts.separator ''
      opts.separator 'Options:'
      # For each option below, place the default
      # at the top of the file next to "default_options"
      # opts.on("-a", "--author=\"Your Name\"", String,
      #         "Some comment about this option",
      #         "Default: none") { |o| options[:author] = o }
      opts.on("-v", "--version", "Show the #{File.basename($0)} version number and quit.")
    end

    def extract_options
      # for each option, extract it into a local variable (and create an "attr_reader :author" at the top)
      # Templates can access these value via the attr_reader-generated methods, but not the
      # raw instance variable value.
      # @author = options[:author]
    end

    # Installation skeleton.  Intermediate directories are automatically
    # created so don't sweat their absence here.
    BASEDIRS = %w(
      dist
      src
      www/WEB-INF
    )
end