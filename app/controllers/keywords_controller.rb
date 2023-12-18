class KeywordsController < ApplicationController
  def index
    @keywords = current_user.keywords
  end

  def show
    @keyword = Keyword.find(params[:id])
  end

  def new
    @keywords = []
  end

  def create
    service = UserKeywordsService.new(current_user.id, keyword_params[:file])
    service.execute
    respond_to do |format|
      if service.status
        format.html { redirect_to keywords_url, notice: 'Keywords was successfully created.' }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  private

  def keyword_params
    params.permit(:file)
  end
end
