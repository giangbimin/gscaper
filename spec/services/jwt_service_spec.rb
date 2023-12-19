# spec/services/jwt_service_spec.rb
require 'rails_helper'

RSpec.describe JwtService, type: :service do
  let(:valid_payload) { { user_id: 1 } }
  let(:expired_payload) { { user_id: 1, exp: 1.hour.ago.to_i } }

  describe '.encode' do
    it 'encodes a valid payload' do
      token = JwtService.encode(valid_payload)
      decoded_payload = JwtService.decode(token)

      expect(decoded_payload[:user_id]).to eq(valid_payload[:user_id])
      expect(decoded_payload[:role]).to eq(valid_payload[:role])
    end
  end

  describe '.decode' do
    context 'with a valid token' do
      it 'decodes the token and returns the payload' do
        valid_token = described_class.encode(valid_payload)
        decoded_payload = described_class.decode(valid_token)

        expect(decoded_payload[:user_id]).to eq(valid_payload[:user_id])
        expect(decoded_payload[:role]).to eq(valid_payload[:role])
      end
    end

    context 'with an expired token' do
      it 'raises an ExpiredSignatureError' do
        expired_token = described_class.encode(expired_payload)
        expect do
          described_class.decode(expired_token)
        end.to raise_error(JwtService::ExpiredSignatureError, /Signature has expired/)
      end
    end

    context 'with an invalid token' do
      it 'raises a DecodeError' do
        invalid_token = 'invalid_token'
        expect {
          described_class.decode(invalid_token)
        }.to raise_error(JwtService::DecodeError)
      end
    end
  end
end
