class UserJwtService
  class JwtRejectedError < StandardError
  end

  class JwtTypeError < StandardError
  end

  class << self
    JWT_EXPIRATION = 15.minutes
    REFRESH_EXPIRATION = 7.days

    def generate_token(user_id, expiration: JWT_EXPIRATION)
      JwtService.encode({ user_id: user_id, type: 'token' }, expiration: expiration)
    end

    def generate_refresh_token(user_id, expiration: REFRESH_EXPIRATION)
      JwtService.encode({ user_id: user_id, type: 'refresh_token' }, expiration: expiration)
    end

    def decode(token, type: 'token')
      raise JwtRejectedError, 'Token invalid' if redis.get(token)

      payload = JwtService.decode(token)
      raise JwtTypeError, 'Token type invalid' if payload[:type] != type

      payload
    end

    def block(token, payload)
      ex = payload[:exp] - Time.now.to_i
      redis.set(token, true, ex: ex) if ex.positive?
    end

    private

    def redis
      Redis.new(url: ENV.fetch('REDIS_URL'))
    end
  end
end
