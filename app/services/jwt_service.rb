# app/services/jwt_service.rb
class JwtService
  ALGORITHM = 'HS256'.freeze
  DEFAULT_EXPIRATION = 24.hours

  class ExpiredSignatureError < StandardError
  end

  class DecodeError < StandardError
  end

  class << self
    def encode(payload, expiration: DEFAULT_EXPIRATION)
      payload[:exp] = expiration.from_now.to_i if payload[:exp].blank?
      JWT.encode(payload, secret_key, ALGORITHM)
    end

    def decode(token)
      decoded_payload = JWT.decode(token, secret_key, true, algorithm: ALGORITHM)[0]
      ActiveSupport::HashWithIndifferentAccess.new(decoded_payload)
    rescue JWT::ExpiredSignature
      raise ExpiredSignatureError, 'Signature has expired'
    rescue JWT::VerificationError, JWT::DecodeError => e
      raise DecodeError, e.message
    end

    private

    def secret_key
      Rails.application.credentials.fetch(:secret_key_base) { 'default_secret_key' }
    end
  end
end
