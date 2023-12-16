require 'rails_helper'

RSpec.describe '/keywords', type: :request do
  before(:each) do
    current_user = FactoryBot.create(:user)
    sign_in current_user
  end

  describe 'GET /index' do
    let(:keyword) { FactoryBot.create(:keyword) }

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

  let(:valid_attributes) { { content: 'google' } }
  let(:invalid_attributes) { {} }

  describe 'POST /create' do
    context 'with valid parameters' do
      it 'creates a new Keyword' do
        expect do
          post keywords_url, params: { keyword: valid_attributes }
        end.to change(Keyword, :count).by(1)
      end

      it 'redirects to the created keyword' do
        post keywords_url, params: { keyword: valid_attributes }
        expect(response).to redirect_to(keyword_url(Keyword.last))
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new Keyword' do
        expect do
          post keywords_url, params: { keyword: invalid_attributes }
        end.to change(Keyword, :count).by(0)
      end

      it 'renders a response with 400 status (i.e. to display the :new template)' do
        post keywords_url, params: { keyword: invalid_attributes }
        expect(response).to have_http_status(:bad_request)
      end
    end
  end
end
