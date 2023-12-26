require 'rails_helper'
require 'sidekiq/testing'

RSpec.describe '/api/v1/keywords', type: :request do
  let(:current_user) { create(:user) }
  let(:content) { Faker::Book.title }
  let(:user_order) { create(:user_order, user: current_user, content: content) }
  let(:token) { UserJwtService.generate_token(current_user.id) }
  let(:headers) { { Authorization: "Bearer #{token}" } }

  before do
    Sidekiq::Testing.fake!
  end

  after do
    Sidekiq::Testing.inline!
  end

  before(:each) do
    redis_instance = instance_double(Redis, get: nil, set: true)
    allow(UserJwtService).to receive(:redis).and_return(redis_instance)
  end

  describe 'GET /index' do
    let!(:keyword) { create(:keyword, user_order: user_order, content: content) }
    context 'without params search' do
      it 'renders a successful response' do
        allow(UserJwtService).to receive(:decode).and_return({ user_id: current_user.id })
        get '/api/v1/keywords', headers: headers
        expect(response).to be_successful
        expect(response.parsed_body['data'].count).to eq(1)
        expect(response.parsed_body['meta_data']['page']).to eq(1)
      end
    end

    context 'with params search' do
      it 'renders a successful response' do
        get '/api/v1/keywords', headers: headers, params: { query: keyword.content }
        expect(response).to be_successful
        expect(response.parsed_body['data'].count).to eq(1)
        expect(response.parsed_body['meta_data']['total']).to eq(1)
      end

      it 'return blank with notfound params' do
        get '/api/v1/keywords', headers: headers, params: { query: 'xxxxxx' }
        expect(response).to be_successful
        expect(response.parsed_body['data'].count).to eq(0)
        expect(response.parsed_body['meta_data']['total']).to eq(0)
      end
    end
  end

  describe 'GET /show' do
    let!(:keyword) { create(:keyword, user_order: user_order, content: content) }

    it 'renders a successful response' do
      get "/api/v1/keywords/#{keyword.id}", headers: headers
      expect(response).to be_successful
      expect(response.parsed_body['data']['id']).to eq(keyword.id)
    end

    it 'renders not_found' do
      get '/api/v1/keywords/11111', headers: headers
      expect(response.parsed_body['error']).to eq('Not Found')
    end
  end

  let(:valid_file) { fixture_file_upload('/csv/sample.csv', 'text/csv') }
  let(:invalid_file) { fixture_file_upload('/csv/many.csv', 'text/csv') }

  describe 'POST /create' do
    context 'with valid parameters' do
      it 'creates a new Keyword' do
        expect do
          post '/api/v1/keywords', headers: headers, params: { file: valid_file }
        end.to change(Keyword, :count).by(3)
      end

      it 'creates a new UserOrder' do
        expect do
          post '/api/v1/keywords', headers: headers, params: { file: valid_file }
        end.to change(UserOrder, :count).by(1)
      end

      it 'redirects to the created keyword' do
        post '/api/v1/keywords', headers: headers, params: { file: valid_file }
        expect(response).to have_http_status(:created)
        expect(response.parsed_body['data']['ids'].count).to eq(3)
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new Keyword' do
        expect do
          post '/api/v1/keywords', headers: headers, params: { file: invalid_file }
        end.to change(Keyword, :count).by(0)
      end

      it 'renders a response with 422 status (i.e. to display the :new template)' do
        post '/api/v1/keywords', headers: headers, params: { file: invalid_file }
        expect(response).to have_http_status(:bad_request)
        expect(response.parsed_body['error']).to eq('Total keywords must be between 1 and 100')
      end
    end
  end
end
