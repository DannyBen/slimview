require 'sinatra/base'
require 'slim'

class Slimview
  def initialize(port: nil, root: nil, **locals)
    @port = port || ENV['SLIMVIEW_PORT']&.to_i || 3000
    @root = root || ENV['SLIMVIEW_ROOT'] || 'templates'
    @locals = locals
  end

  def start = app.run!
  def app = App.build(root: @root, port: @port, locals: @locals)

  class App < Sinatra::Base
    def self.build(root:, port:, locals:)
      Slim::Engine.set_options pretty: true

      set :bind, '0.0.0.0'
      set :port, port
      set :views, root
      set :root, File.expand_path('.')
      set :public_folder, File.join(settings.root, 'assets')
      set :environment, :development
      set :reload_templates, true

      define_method :locals do
        locals
      end

      get '/*' do
        page = params[:splat].first
        page = 'index' if page.empty?
        slim_path = File.join(settings.views, "#{page}.slim")
        halt 404, "Template not found: #{page}" unless File.exist?(slim_path)

        slim page.to_sym, locals: locals
      end

      self
    end
  end
end
