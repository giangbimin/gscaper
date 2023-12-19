module Api
  class ApplicationController < ActionController::API
    include ActionController::MimeResponds
    respond_to :json

    before_action :jwt_authenticate!

    private

    def jwt_authenticate!
      header = request.headers['Authorization']
      payload = JwtService.decode(header.split.last)
      @current_user = User.find(payload['user_id'])
    rescue JWT::DecodeError, JWT::ExpiredSignature, JWT::VerificationError
      render json: { error: 'Invalid token' }, status: :unauthorized
    rescue StandardError
      render json: { error: 'Please Login' }, status: :unauthorized
    end
  end
end
