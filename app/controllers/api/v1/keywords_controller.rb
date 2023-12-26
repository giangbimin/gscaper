module Api
  module V1
    class KeywordsController < Api::ApplicationController
      def index
        keywords = @current_user.keywords
        keywords = keywords.search(search_params[:query]) if search_params[:query].present?
        pagy, keywords = pagy(keywords)
        render json: KeywordsSerializer.new(keywords, metadata(pagy))
      end

      def show
        keyword = @current_user.keywords.find_by(id: params[:id])
        if keyword.present?
          render json: KeywordSerializer.new(keyword)
        else
          render_errors({ details: 'Not Found', code: :not_found }, status: :not_found)
        end
      end

      def create
        user_order = UserOrderForm.new(@current_user, keyword_params[:file])
        if user_order.save
          render json: UserOrderFormSerializer.new(user_order), status: :created
        else
          render_errors({details: user_order.errors.full_messages.join(', '), code: :validation_error})
        end
      end

      private

      def keyword_params
        params.permit(:file)
      end

      def search_params
        params.permit(:query)
      end
    end
  end
end
