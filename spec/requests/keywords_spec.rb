require 'rails_helper'

RSpec.describe '/keywords', type: :request do
  before(:each) do
    current_user = FactoryBot.create(:user)
    sign_in current_user
  end

  describe 'GET /index' do
    let(:keyword) { FactoryBot.create(:keyword, user: current_user) }
    let(:user_keyword) { FactoryBot.create(:user_keyword, user: current_user, keyword: keyword) }

    it 'renders a successful response' do
      get keywords_url
      expect(response).to be_successful
    end
  end

  describe 'GET /show' do
    let(:keyword) { FactoryBot.create(:keyword) }

    it 'renders a successful response' do
      get keyword_url(keyword)
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
          post keywords_url, params: { file: valid_file }
        end.to change(Keyword, :count).by(3)
      end

      it 'creates a new Userkeyword' do
        expect do
          post keywords_url, params: { file: valid_file }
        end.to change(UserKeyword, :count).by(3)
      end

      it 'redirects to the created keyword' do
        post keywords_url, params: { file: valid_file }
        expect(response).to redirect_to(keywords_url)
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new Keyword' do
        expect do
          post keywords_url, params: { file: invalid_file }
        end.to change(Keyword, :count).by(0)
      end

      it 'renders a response with 422 status (i.e. to display the :new template)' do
        post keywords_url, params: { file: invalid_file }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
