require 'rack/mock'
require 'slimview/server'

module Slimview
  class RenderError < StandardError
    attr_reader :status

    def initialize(status:, body:)
      @status = status
      message = "Render failed with HTTP #{status}"
      body = body.to_s.strip
      message = "#{message}: #{body}" unless body.empty?

      super message
    end
  end

  class Renderer
    def initialize(root: nil, assets: nil, components: nil, **locals)
      @server = Server.new root: root, assets: assets, components: components, raise_errors: true, **locals
    end

    def render(path = '/')
      response = Rack::MockRequest.new(@server.app).get(path)
      raise RenderError.new(status: response.status, body: response.body) unless response.ok?

      response.body
    end
  end
end
