require 'rails_helper'

RSpec.describe '/api/v1/keywords', type: :request do
  let(:current_user) { create(:user) }
  let(:token) { JwtService.encode({ user_id: current_user.id }) }
  let(:headers) { { Authorization: "Bearer #{token}" } }

  describe 'GET /index' do
    let!(:keyword) { create(:keyword) }
    let!(:user_keyword) { create(:user_keyword, user: current_user, keyword: keyword) }

    context 'without params search' do
      it 'renders a successful response' do
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
    let!(:keyword) { create(:keyword) }
    let!(:user_keyword) { create(:user_keyword, user: current_user, keyword: keyword) }

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

      it 'creates a new Userkeyword' do
        expect do
          post '/api/v1/keywords', headers: headers, params: { file: valid_file }
        end.to change(UserKeyword, :count).by(3)
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
        expect(response.parsed_body['error']).to eq('Total keywords must between 1 and 100')
      end
    end
  end
end
