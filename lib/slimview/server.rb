module Slimview
  class Server
    def initialize(port: nil, root: nil, **locals)
      @port = port || ENV['SLIMVIEW_PORT']&.to_i || 3000
      @root = root || ENV['SLIMVIEW_ROOT'] || 'templates'
      @locals = locals
    end

    def start = app.run!
    def app = App.configure!(root: @root, port: @port, locals: @locals)
  end
end
