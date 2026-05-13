module Slimview
  class Server
    def initialize(**options)
      @port = configured_port options
      @root = configured_path options, :root, 'SLIMVIEW_ROOT', 'templates'
      @assets = configured_path options, :assets, 'SLIMVIEW_ASSETS', "#{@root}/assets"
      @components = configured_path options, :components, 'SLIMVIEW_COMPONENTS', "#{@root}/components"
      @raise_errors = options.delete(:raise_errors) || false
      @locals = options
    end

    def start = app.run!

    def app
      config = {
        port:         @port,
        root:         @root,
        assets:       @assets,
        components:   @components,
        locals:       @locals,
        raise_errors: @raise_errors,
      }

      Class.new(App).configure!(**config)
    end

  private

    def configured_port(options)
      (options.delete(:port) || ENV['SLIMVIEW_PORT'] || 3000).to_i
    end

    def configured_path(options, option, environment, default)
      options.delete(option) || ENV[environment] || default
    end
  end
end
