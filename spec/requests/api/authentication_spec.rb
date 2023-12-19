require 'rails_helper'

RSpec.describe '/api/sign_in', type: :request do
  let(:current_user) { create(:user, password: '123456') }
  let(:valid_params) { { authentication: { email: current_user.email, password: '123456' } } }
  let(:invalid_params) { { authentication: { email: current_user.email, password: '111111' } } }
  let(:fake_token) { JwtService.encode({ user_id: current_user.id }) }

  describe 'POST /sign_in' do
    context 'with valid email and password' do
      it 'renders a successful response' do
        allow(JwtService).to receive(:encode).and_return(fake_token)
        post '/api/sign_in', params: valid_params
        expect(response).to be_successful
        expect(response.parsed_body['token']).to eq(fake_token)
      end
    end

    context 'with invalid email or password' do
      it 'renders a successful response' do
        post '/api/sign_in', params: invalid_params
        expect(response).to have_http_status(:unauthorized)
        expect(response.parsed_body['error']).to eq('Invalid email or password')
      end
    end
  end
end
