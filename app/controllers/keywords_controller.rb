class KeywordsController < ApplicationController
  def index
    @keywords = Keyword.all
  end

  def show
    @keyword = Keyword.find(params[:id])
  end

  def new
    @keyword = Keyword.new
  end

  def create
    @keyword = Keyword.new(keyword_params)

    respond_to do |format|
      if @keyword.save
        format.html { redirect_to keyword_url(@keyword), notice: 'Keyword was successfully created.' }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_keyword
  end

  def keyword_params
    params.require(:keyword).permit(:content)
  end

  def keywords_file_params
    params.require(:keywords).permit(:file)
  end
end
