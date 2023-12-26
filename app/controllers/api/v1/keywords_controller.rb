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
          head :not_found
        end
      end

      def create
        user_order = UserOrderForm.new(@current_user, keyword_params[:file])
        if user_order.save
          head :created
        else
          render_errors([{ detail: user_order.errors.full_messages.join(', '), code: :validation_error }])
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
