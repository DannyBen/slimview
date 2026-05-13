require 'mister_bin'
require 'fileutils'
require 'slimview/version'
require 'slimview/server'
require 'slimview/app'
require 'slimview/renderer'

module Slimview
  class Command < MisterBin::Command
    DOT_ENTRIES = ['.', '..'].freeze
    TEMPLATE_ROOT = File.expand_path('templates', __dir__)

    summary 'Run a slim server'
    version VERSION

    usage 'slimview [--port PORT] [--root PATH] [--assets PATH] [--components PATH]'
    usage 'slimview init [DIR] [--force]'
    usage 'slimview check [--root PATH] [--assets PATH] [--components PATH]'
    usage 'slimview render [FILENAME] [--root PATH] [--assets PATH] [--components PATH]'
    usage 'slimview --help | -h | --version'

    command 'check', 'Check that the index page can render'
    command 'init', 'Create a new baseline workspace'
    command 'render', 'Render the index page HTML'

    option '-p --port PORT', 'Set the port to run the server on (default: 3000)'
    option '-r --root PATH', 'Set the root templates directory (default: ./templates)'
    option '-a --assets PATH', 'Set the assets directory (default: <root>/assets)'
    option '-c --components PATH', 'Set the components directory (default: <root>/components)'
    option '-f --force', 'Copy files even when the target directory is not empty'

    param 'DIR', 'The workspace directory to initialize (default: .)'
    param 'FILENAME', 'The HTML file to write (default: stdout)'

    environment 'SLIMVIEW_PORT', 'Set the port'
    environment 'SLIMVIEW_ROOT', 'Set the root templates directory'
    environment 'SLIMVIEW_ASSETS', 'Set the assets directory'
    environment 'SLIMVIEW_COMPONENTS', 'Set the components directory'

    def run
      port = args['--port']
      root = args['--root']
      assets = args['--assets']
      components = args['--components']
      port = port.to_i if port

      server = Slimview::Server.new port: port, root: root, assets: assets, components: components
      server.start
    end

    def init_command
      target = File.expand_path(args['DIR'] || '.', Dir.pwd)
      force = args['--force']

      if File.exist?(target) && !File.directory?(target)
        raise "Path exists and is not a directory: #{target}"
      end

      FileUtils.mkdir_p target

      if !force && !Dir.empty?(target)
        raise "Directory is not empty: #{target}"
      end

      copy_template_workspace target
      puts "Initialized Slimview workspace in #{target}"
    end

    def check_command
      render_html
      0
    end

    def render_command
      path = args['FILENAME']
      html = render_html

      if path.nil? || path == '-'
        puts html
        return 0
      end

      target = File.expand_path(path, Dir.pwd)

      if File.directory? target
        raise "Path exists and is a directory: #{target}"
      end

      FileUtils.mkdir_p File.dirname(target)
      File.write target, html
      0
    end

  private

    def render_html
      root = args['--root']
      assets = args['--assets']
      components = args['--components']

      Slimview::Renderer.new(root: root, assets: assets, components: components).render
    end

    def copy_template_workspace(target)
      templates_target = File.join(target, 'templates')

      Dir.glob(File.join(TEMPLATE_ROOT, '**', '*'), File::FNM_DOTMATCH).each do |source|
        next if DOT_ENTRIES.include? File.basename(source)

        destination = File.join(templates_target, source.delete_prefix("#{TEMPLATE_ROOT}/"))

        if File.directory? source
          FileUtils.mkdir_p destination
        else
          FileUtils.mkdir_p File.dirname(destination)
          FileUtils.cp source, destination
        end
      end
    end
  end
end
