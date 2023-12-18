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

  def filter_keywords
    csv_parser_service = CsvKeywordsParserService.new(@file)
    @keyword_list = csv_parser_service.execute
    errors.merge!(csv_parser_service.errors) unless csv_parser_service.status
  end

  def save_keywords
    @keyword_ids = []
    ActiveRecord::Base.transaction do
      @keyword_list.each do |content|
        @keyword_ids << create_keyword(content)
      end
    end
  rescue StandardError => e
    @keyword_ids = []
    errors[:base] = "Errors: #{e}"
  end

  def create_keyword(content)
    keyword_id = Keyword.find_or_create_by(content: content).id
    UserKeyword.find_or_create_by(user: @user_id, keyword_id: keyword_id)
    keyword_id
  end

  def perform_scraper; end
end
