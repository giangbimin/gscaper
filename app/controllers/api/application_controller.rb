module Api
  class ApplicationController < ActionController::API
    include ActionController::MimeResponds
    include Pagy::Backend

    respond_to :json

    before_action :jwt_authenticate!

    private

    def jwt_authenticate!
      header = request.headers['Authorization']
      @jwt_token = header.split.last
      @payload = UserJwtService.decode(@jwt_token)
      @current_user = User.find(@payload[:user_id])
    rescue JWT::DecodeError, JWT::ExpiredSignature, JWT::VerificationError, UserJwtService::JwtTypeError
      render json: { error: 'Invalid token' }, status: :unauthorized
    rescue StandardError, UserJwtService::JwtRejectedError
      render json: { error: 'Please Login' }, status: :unauthorized
    end
  end
end
