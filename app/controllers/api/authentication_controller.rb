module Api
  class AuthenticationController < Api::ApplicationController
    skip_before_action :jwt_authenticate!, only: %i[sign_in refresh]

    def sign_in
      user = User.find_by(email: login_params[:email])

      if user&.valid_password?(login_params[:password])
        render json: { data: login_response(user.id) }, status: :ok
      else
        render json: { error: 'Invalid email or password' }, status: :unauthorized
      end
    end

    def refresh
      payload = UserJwtService.decode(refresh_params[:refresh_token], type: 'refresh_token')
      render json: { data: refresh_response(payload[:user_id]) }, status: :ok
    rescue JWT::DecodeError, JWT::ExpiredSignature, JWT::VerificationError, UserJwtService::JwtTypeError
      render json: { error: 'Invalid token' }, status: :unauthorized
    rescue StandardError, UserJwtService::JwtRejectedError
      render json: { error: 'Please Login' }, status: :unauthorized
    end

    def sign_out
      UserJwtService.block(@jwt_token, @payload)
      render json: { data: { message: 'Logout Success' } }, status: :ok
    end

    private

    def login_response(user_id)
      { token: UserJwtService.generate_token(user_id), refresh_token: UserJwtService.generate_refresh_token(user_id) }
    end

    def refresh_response(user_id)
      { token: UserJwtService.generate_token(user_id), refresh_token: refresh_params[:refresh_token] }
    end

    def login_params
      params.require(:authentication).permit(:email, :password)
    end

    def refresh_params
      params.require(:authentication).permit(:refresh_token)
    end
  end
end
