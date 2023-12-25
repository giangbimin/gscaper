# spec/services/user_jwt_service_spec.rb
require 'rails_helper'

RSpec.describe UserJwtService, type: :service do
  let(:user_id) { 1 }
  let(:token) { described_class.generate_token(user_id) }
  let(:refresh_token) { described_class.generate_refresh_token(user_id) }

  describe '.generate_token' do
    it 'generates a JWT token' do
      result = described_class.generate_token(user_id)
      expect(result).to be_a(String)
    end
  end

  describe '.generate_refresh_token' do
    it 'generates a refresh token' do
      result = described_class.generate_refresh_token(user_id)
      expect(result).to be_a(String)
    end
  end

  describe '.decode' do
    context 'with a valid token' do
      it 'decodes a JWT token and returns the payload' do
        redis_instance = instance_double(Redis, get: nil)
        allow(UserJwtService).to receive(:redis).and_return(redis_instance)
        result = described_class.decode(token)
        expect(result).to include('user_id' => user_id)
      end
    end

    context 'with a blocked token' do
      it 'raises JWTRejectedError' do
        redis_instance = instance_double(Redis, get: 'true')
        allow(UserJwtService).to receive(:redis).and_return(redis_instance)
        expect { described_class.decode(token) }.to raise_error(UserJwtService::JwtRejectedError, 'Token invalid')
      end
    end

    context 'with a invalid token type' do
      it 'decodes a JWT token and returns the payload' do
        redis_instance = instance_double(Redis, get: nil)
        allow(UserJwtService).to receive(:redis).and_return(redis_instance)
        expect { described_class.decode(token, type: 'refresh_token') }.to raise_error(UserJwtService::JwtTypeError, 'Token type invalid')
      end
    end
  end

  describe '.block' do
    it 'blocks a token' do
      redis_instance = instance_double(Redis, set: true)
      payload = JwtService.decode(token)
      allow(UserJwtService).to receive(:redis).and_return(redis_instance)
      result = described_class.block(token, payload)
      expect(result).to eq(true)
    end
  end
end
