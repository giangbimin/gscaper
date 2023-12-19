module Api
  module V1
    class KeywordsController < Api::ApplicationController
      def index
        keywords = @current_user.keywords
                                .select(:id, :content, :status, :total_link, :total_result, :total_ad)
                                .as_json(except: %i[created_at updated_at html_code])
        render json: { data: keywords }, status: :ok
      end

      def show
        keyword = @current_user.keywords.find_by(id: params[:id])
        if keyword.present?
          render json: { data: keyword.as_json }, status: :ok
        else
          render json: { error: 'Not Found' }, status: :not_found
        end
      end

      def create
        status, errors, keyword_ids = execute_keyword_service
        if status
          render json: { data: { ids: keyword_ids } }, status: :created
        else
          render json: { error: errors.values.join(', ') }, status: :bad_request
        end
      end

      private

      def keyword_params
        params.permit(:file)
      end

      def execute_keyword_service
        service = UserKeywordsService.new(@current_user, keyword_params[:file])
        service.execute
        [service.status, service.errors, service.keyword_ids]
      end
    end
  end
end
