require 'rack/test'

describe Slimview::App do
  include Rack::Test::Methods

  let(:app) { Slimview::Server.new(**options).app }
  let(:options) { { root: root }.merge context }
  let(:root) { 'spec/fixtures/templates' }
  let(:context) { {} }

  it 'resolves configured paths from the working directory' do
    expect(app.settings.views).to eq File.expand_path(root, Dir.pwd)
    expect(app.settings.public_folder).to eq File.expand_path("#{root}/assets", Dir.pwd)
    expect(app.settings.slimview_components).to eq File.expand_path("#{root}/components", Dir.pwd)
  end

  describe 'GET /' do
    before { get '/' }

    it 'returns 200 OK' do
      expect(last_response).to be_ok
    end

    it 'respects layout.slim' do
      expect(last_response.body).to include 'Slimview layout is included'
    end

    it 'shows embedded slim partials' do
      expect(last_response.body).to include 'This is a partial snippet'
    end
  end

  describe 'GET /secret' do
    before { get '/secret' }

    it 'returns 200' do
      expect(last_response).to be_ok
    end

    context 'with context variables' do
      let(:context) { { secret: 'There is no spoon' } }

      it 'makes the variables available in the template' do
        expect(last_response.body).to include 'There is no spoon'
      end
    end
  end

  describe 'GET /non_existent_template' do
    before { get '/non_existent_template' }

    it 'returns 404 Not Found' do
      expect(last_response.status).to eq(404)
    end
  end

  describe 'GET /style.css' do
    before { get '/style.css' }

    it 'serves assets from the configured directory' do
      expect(last_response).to be_ok
      expect(last_response.headers['Content-Type']).to include('text/css')
    end
  end

  describe 'GET /component_test' do
    before { get '/component_test' }

    it 'renders components from the default components directory' do
      expect(last_response).to be_ok
      expect(last_response.body).to include 'Component OK'
    end
  end

  describe 'GET /custom_component_test' do
    let(:options) { { root: root, components: 'spec/fixtures/custom_components' }.merge context }

    before { get '/custom_component_test' }

    it 'renders components from the configured components directory' do
      expect(last_response).to be_ok
      expect(last_response.body).to include 'Custom OK'
    end
  end
end
