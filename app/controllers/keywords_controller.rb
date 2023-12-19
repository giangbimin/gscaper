class KeywordsController < ApplicationController
  def index
    @keywords = current_user.keywords
  end

  def show
    @keyword = current_user.keywords.find_by(id: params[:id])
    render file: Rails.public_path.join('404.html').to_s, status: :not_found, layout: false unless @keyword
  end

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

  private

  def keyword_params
    params.permit(:file)
  end

  def execute_keyword_service
    service = UserKeywordsService.new(current_user, keyword_params[:file])
    service.execute
    [service.status, service.errors]
  end
end
