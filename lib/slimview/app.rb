require 'sinatra/base'
require 'slim'

module Slimview
  class App < Sinatra::Base
    module TemplateHelpers
      def component(path, **locals)
        slim path.to_sym, views: settings.slimview_components, layout: false, locals: locals
      end
    end

    def self.configure!(root:, port:, assets:, components:, locals:)
      Slim::Engine.set_options pretty: true

      configure_paths root, assets, components
      configure_server port, locals
      configure_routes

      self
    end

    def self.configure_server(port, locals)
      set :bind, '0.0.0.0'
      set :port, port
      set :environment, :development
      set :reload_templates, true
      set :protection, except: :host_authorization
      set :host_authorization, permitted_hosts: []
      set :slimview_locals, locals
      helpers TemplateHelpers
    end

    def self.configure_routes
      get '/*' do
        page = params[:splat].first
        page = 'index' if page.empty?
        slim_path = File.join(settings.views, "#{page}.slim")
        halt 404, "Template not found: #{page}" unless File.exist?(slim_path)

        slim page.to_sym, locals: settings.slimview_locals
      end
    end

    def self.configure_paths(root, assets, components)
      set :views, File.expand_path(root, Dir.pwd)
      set :root, File.expand_path('.')
      set :public_folder, File.expand_path(assets, Dir.pwd)
      set :slimview_components, File.expand_path(components, Dir.pwd)
    end
  end
end
