module Slimview
  class Server
    def initialize(port: nil, root: nil, assets: nil, **locals)
      @port = port || ENV['SLIMVIEW_PORT']&.to_i || 3000
      @root = root || ENV['SLIMVIEW_ROOT'] || 'templates'
      @assets = assets || ENV['SLIMVIEW_ASSETS'] || "#{@root}/assets"
      @locals = locals
    end

    def start = app.run!
    def app = App.configure!(port: @port, root: @root, assets: @assets, locals: @locals)
  end
end
