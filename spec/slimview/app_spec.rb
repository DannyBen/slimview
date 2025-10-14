require 'rack/test'

describe Slimview do
  include Rack::Test::Methods

  let(:app) { Slimview.new.app }

  describe 'GET /' do
    # it 'returns 200 OK for the index page' do
    #   get '/'
    #   expect(last_response).to be_ok
    # end

    it 'returns 404 for a non-existent template' do
      get '/non_existent'
      expect(last_response.status).to eq(404)
    end
  end
end
