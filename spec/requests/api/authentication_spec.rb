require 'rails_helper'

RSpec.describe '/api/sign_in', type: :request do
  let(:current_user) { create(:user, password: '123456') }
  let(:valid_params) { { authentication: { email: current_user.email, password: '123456' } } }
  let(:invalid_params) { { authentication: { email: current_user.email, password: '111111' } } }
  let(:token) { UserJwtService.generate_token(current_user.id) }
  let(:expired_refresh_token) { JwtService.encode({ user_id: current_user.id, exp: 1.hour.ago.to_i }) }
  let(:refresh_token) { UserJwtService.generate_refresh_token(current_user.id) }
  let(:headers) { { Authorization: "Bearer #{token}" } }

  describe 'POST /sign_in' do
    context 'with valid email and password' do
      it 'renders a successful response' do
        allow(UserJwtService).to receive(:generate_token).and_return(token)
        allow(UserJwtService).to receive(:generate_refresh_token).and_return(refresh_token)
        post '/api/sign_in', params: valid_params
        expect(response).to be_successful
        expect(response.parsed_body['meta']['token']).to eq(token)
        expect(response.parsed_body['meta']['refresh_token']).to eq(refresh_token)
      end
    end

    context 'with invalid email or password' do
      it 'renders a successful response' do
        post '/api/sign_in', params: invalid_params
        expect(response).to have_http_status(:unauthorized)
        expect(response.parsed_body['errors'][0]['detail']).to eq('Invalid email or password')
      end
    end
  end

  describe 'POST /refresh' do
    context 'with valid refresh_token' do
      let(:new_token) { UserJwtService.generate_token(current_user.id) }
      it 'renders a successful response' do
        allow(UserJwtService).to receive(:decode).and_return({ user_id: current_user.id, type: 'refesh_token' })
        allow(UserJwtService).to receive(:generate_token).and_return(new_token)
        post '/api/refresh', params: { authentication: { refresh_token: refresh_token } }
        expect(response).to be_successful
        expect(response.parsed_body['meta']['token']).to eq(new_token)
        expect(response.parsed_body['meta']['refresh_token']).to eq(refresh_token)
      end
    end

    context 'with expired refresh_token' do
      it 'renders a successful response' do
        post '/api/refresh', params: { authentication: { refresh_token: expired_refresh_token } }
        expect(response).to have_http_status(:unauthorized)
        expect(response.parsed_body['errors'][0]['detail']).to eq('Please Login')
      end
    end

    context 'with blocked refresh_token' do
      it 'renders a successful response' do
        redis_instance = instance_double(Redis, get: 'true')
        allow(UserJwtService).to receive(:redis).and_return(redis_instance)
        post '/api/refresh', params: { authentication: { refresh_token: refresh_token } }
        expect(response).to have_http_status(:unauthorized)
        expect(response.parsed_body['errors'][0]['detail']).to eq('Please Login')
      end
    end

    context 'with invalid token type' do
      it 'renders a unauthorized response' do
        redis_instance = instance_double(Redis, get: nil, set: true)
        allow(UserJwtService).to receive(:redis).and_return(redis_instance)
        post '/api/refresh', params: { authentication: { refresh_token: token } }
        expect(response).to have_http_status(:unauthorized)
        expect(response.parsed_body['errors'][0]['detail']).to eq('Invalid token')
      end
    end
  end

  describe 'POST /sign_out' do
    context 'with valid email and password' do
      it 'renders a successful response' do
        redis_instance = instance_double(Redis, get: nil, set: true)
        allow(UserJwtService).to receive(:redis).and_return(redis_instance)
        post '/api/sign_out', headers: headers
        expect(response).to be_successful
      end
    end

    context 'with invalid token header' do
      it 'renders a successful response' do
        redis_instance = instance_double(Redis, get: nil, set: true)
        allow(UserJwtService).to receive(:redis).and_return(redis_instance)
        post '/api/sign_out'
        expect(response).to have_http_status(:unauthorized)
        expect(response.parsed_body['errors'][0]['detail']).to eq('Please Login')
      end
    end
  end
end
