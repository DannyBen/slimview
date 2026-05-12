require 'mister_bin'
require 'slimview/version'
require 'slimview/server'
require 'slimview/app'

module Slimview
  class Command < MisterBin::Command
    summary 'Run a slim server'
    version VERSION

    usage 'slimview [options]'

    option '-p --port PORT', 'Set the port to run the server on (default: 3000)'
    option '-r --root PATH', 'Set the root templates directory (default: ./templates)'
    option '-a --assets PATH', 'Set the assets directory (default: <root>/assets)'
    option '-c --component PATH', 'Set the components directory (default: <root>/components)'

    environment 'SLIMVIEW_PORT', 'Set the port'
    environment 'SLIMVIEW_ROOT', 'Set the root templates directory'
    environment 'SLIMVIEW_ASSETS', 'Set the assets directory'
    environment 'SLIMVIEW_COMPONENTS', 'Set the components directory'

    def run
      port = args['--port']
      root = args['--root']
      assets = args['--assets']
      components = args['--component']
      port = port.to_i if port

      server = Slimview::Server.new port: port, root: root, assets: assets, components: components
      server.start
    end
  end
end
