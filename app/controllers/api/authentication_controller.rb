module Api
  class AuthenticationController < Api::ApplicationController
    skip_before_action :jwt_authenticate!

    def sign_in
      user = User.find_by(email: login_params[:email])

      if user&.valid_password?(login_params[:password])
        render json: { token: JwtService.encode({ user_id: user.id }) }
      else
        render json: { error: 'Invalid email or password' }, status: :unauthorized
      end
    end

    private

    def login_params
      params.require(:authentication).permit(:email, :password)
    end
  end
end
