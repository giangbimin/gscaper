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
    user_order = UserOrderForm.new(current_user, keyword_params[:file])
    respond_to do |format|
      if user_order.save
        format.html { redirect_to keywords_url, notice: 'Keywords was successfully created.' }
      else
        flash.alert = user_order.errors.full_messages[0]
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
    params.require(:keywords).permit(:file)
  end

  def search_params
    params.permit(:query)
  end

  def find_keyword
    @keyword = current_user.keywords.find_by(id: params[:id] || params[:keyword_id])
    render file: Rails.public_path.join('404.html').to_s, status: :not_found, layout: false unless @keyword
  end
end
