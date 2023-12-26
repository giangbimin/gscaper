require 'rails_helper'
require 'sidekiq/testing'

RSpec.describe '/keywords', type: :request do
  let(:current_user) { create(:user) }
  let(:content) { Faker::Book.title }
  let(:user_order) { create(:user_order, user: current_user, content: content) }

  before do
    Sidekiq::Testing.fake!
  end

  after do
    Sidekiq::Testing.inline!
  end

  before(:each) do
    sign_in current_user
  end

  describe 'GET /index' do
    let!(:keyword) { create(:keyword, user_order: user_order, content: content) }
    context 'without params search' do
      it 'renders a successful response' do
        get keywords_url
        expect(response).to be_successful
      end
    end

    context 'with params search' do
      it 'renders a successful response' do
        get keywords_url, params: { query: keyword.content }
        expect(response).to be_successful
      end

      it 'return blank with notfound params' do
        get keywords_url, params: { query: 'xxxxxx' }
        expect(response).to be_successful
      end
    end
  end

  describe 'GET /show' do
    let!(:keyword) { create(:keyword, user_order: user_order, content: content) }
    let!(:keyword2) { create(:keyword, content: content) }

    it 'renders a successful response' do
      get keyword_url(keyword)
      expect(response).to be_successful
    end

    it 'renders a not found response' do
      get keyword_url(keyword2)
      expect(response.status).to eq(404)
    end
  end

  describe 'POST /refresh' do
    let!(:keyword) { create(:keyword, user_order: user_order, content: content) }

    it 'renders a successful response' do
      post keyword_refresh_url(keyword)
      expect(response).to be_successful
    end
  end

  describe 'GET /new' do
    it 'renders a successful response' do
      get new_keyword_url
      expect(response).to be_successful
    end
  end

  let(:valid_file) { fixture_file_upload('/csv/sample.csv', 'text/csv') }
  let(:invalid_file) { fixture_file_upload('/csv/many.csv', 'text/csv') }

  describe 'POST /create' do
    context 'with valid parameters' do
      it 'creates a new Keyword' do
        expect do
          post keywords_url, params: { keywords: { file: valid_file } }
        end.to change(Keyword, :count).by(3)
      end

      it 'creates a new UserOrder' do
        expect do
          post keywords_url, params: { keywords: { file: valid_file } }
        end.to change(UserOrder, :count).by(1)
      end

      it 'redirects to the created keyword' do
        post keywords_url, params: { keywords: { file: valid_file } }
        expect(response).to redirect_to(keywords_url)
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new Keyword' do
        expect do
          post keywords_url, params: { keywords: { file: invalid_file } }
        end.to change(Keyword, :count).by(0)
      end

      it 'renders a response with 422 status (i.e. to display the :new template)' do
        post keywords_url, params: { keywords: { file: invalid_file } }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
