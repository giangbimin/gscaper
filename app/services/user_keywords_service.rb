class UserKeywordsService
  attr_reader :keywords, :errors

  def initialize(user_id, file)
    @user_id = user_id
    @file = file
    @errors = {}
  end

  def execute
    filter_keywords
    return unless status

    save_keywords
    return unless status

    perform_scraper
  end

  def status
    errors.blank?
  end

  private

  def filter_keywords; end

  def save_keywords; end

  def perform_scraper; end
end
