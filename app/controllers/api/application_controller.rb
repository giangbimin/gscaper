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
      render_errors([{ detail: 'Invalid token', code: :unauthorized }], status: :unauthorized)
    rescue StandardError, UserJwtService::JwtRejectedError
      render_errors([{ detail: 'Please Login', code: :unauthorized }], status: :unauthorized)
    end

    def render_errors(errors, status: :unprocessable_entity)
      render json: { errors: errors }, status: status
    end

    def metadata(pagy)
      {
        meta: {
          total: pagy.count,
          per: pagy.items,
          page: pagy.page,
          pages: pagy.pages,
          last: pagy.last
        }
      }
    end
  end
end
