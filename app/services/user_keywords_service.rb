class UserKeywordsService < ApplicationService
  JOB_INTERVAL = 2
  attr_reader :keywords, :errors, :keyword_ids

  def initialize(user, file)
    @user = user
    @file = file
    super
  end

  def execute
    filter_keywords
    return unless status

    save_keywords
    return unless status

    perform_scraper
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
        keyword_ids << create_keyword(content)
      end
    end
  rescue StandardError => e
    @keyword_ids = []
    errors[:base] = e.message
  end

  def create_keyword(content)
    keyword_id = Keyword.find_or_create_by(content: content).id
    UserKeyword.find_or_create_by(user: @user, keyword_id: keyword_id)
    keyword_id
  end

  def perform_scraper
    keyword_ids.compact.each_with_index do |keyword_id, index|
      KeywordScraperJob.perform_in((index * JOB_INTERVAL).seconds, keyword_id)
    end
  end
end
