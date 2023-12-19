class KeywordsController < ApplicationController
  before_action :find_keyword, only: %i[show refresh]

  def index
    keywords = current_user.keywords
    keywords = keywords.search(search_params[:query]) if search_params[:query].present?
    @pagy, @keywords = pagy(keywords)
  end

  def show; end

  def new
    @keywords = []
  end

  def create
    status, errors = execute_keyword_service
    respond_to do |format|
      if status
        format.html { redirect_to keywords_url, notice: 'Keywords was successfully created.' }
      else
        flash.alert = errors.values[0]
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def refresh
    jid = KeywordScraperJob.perform_async(@keyword.id)
    render json: { jid: jid }, status: :ok
  end

  private

  def keyword_params
    params.permit(:file)
  end

  def search_params
    params.permit(:query)
  end

  def execute_keyword_service
    service = UserKeywordsService.new(current_user, keyword_params[:file])
    service.execute
    [service.status, service.errors]
  end

  def find_keyword
    @keyword = current_user.keywords.find_by(id: params[:id] || params[:keyword_id])
    render file: Rails.public_path.join('404.html').to_s, status: :not_found, layout: false unless @keyword
  end
end
