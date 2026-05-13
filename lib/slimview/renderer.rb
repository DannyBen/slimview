require 'rack/mock'
require 'slimview/server'

module Slimview
  class Renderer
    def initialize(root: nil, assets: nil, components: nil, **locals)
      @server = Server.new root: root, assets: assets, components: components, **locals
    end

    def render(path = '/')
      response = Rack::MockRequest.new(@server.app).get(path)
      raise response.body unless response.ok?

      response.body
    end
  end
end
