require 'rack/test'

describe Slimview do
  include Rack::Test::Methods

  let(:app) { Slimview::Server.new(**options).app }
  let(:options) { { root: root }.merge context }
  let(:root) { 'spec/fixtures/templates' }
  let(:context) { {} }

  describe 'GET /' do
    it 'returns 200 OK' do
      get '/'
      expect(last_response).to be_ok
    end
  end

  describe 'GET /secret' do
    it 'returns 200' do
      get '/secret'
      expect(last_response).to be_ok
    end

    context 'with context variables' do
      let(:context) { { secret: "There is no spoon" } }
      it 'makes the variables available in the template' do
        get '/secret'
        expect(last_response.body).to include "There is no spoon"
      end
    end
  end

  describe 'GET /non_existent_template' do
    it 'returns 404 Not Found' do
      get '/non_existent_template'
      expect(last_response.status).to eq(404)
    end
  end
end
