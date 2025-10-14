require 'sinatra/base'
require 'slim'

module Slimview
  class App < Sinatra::Base
    def self.configure!(root:, port:, assets:, locals:)
      Slim::Engine.set_options pretty: true

      views_path = File.expand_path(root, Dir.pwd)

      set :bind, '0.0.0.0'
      set :port, port
      set :views, views_path
      set :root, File.expand_path('.')
      set :public_folder, assets
      set :environment, :development
      set :reload_templates, true
      set :protection, except: :host_authorization
      set :host_authorization, permitted_hosts: []
      set :slimview_locals, locals

      get '/*' do
        page = params[:splat].first
        page = 'index' if page.empty?
        slim_path = File.join(settings.views, "#{page}.slim")
        halt 404, "Template not found: #{page}" unless File.exist?(slim_path)

        slim page.to_sym, locals: settings.slimview_locals
      end

      self
    end
  end
end
