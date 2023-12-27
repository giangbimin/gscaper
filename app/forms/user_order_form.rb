class UserOrderForm
  JOB_INTERVAL = 2
  include ActiveModel::Model
  validates_with CsvKeywordsValidator

  attr_reader :file, :current_user, :keywords, :keyword_ids, :jids, :id

  def initialize(current_user, file)
    @current_user = current_user
    @file = file
    @keywords = []
    @keyword_ids = []
    @jids = []
  end

  def save
    return false unless valid?

    preview
    return false if keywords.blank?

    return false unless save_keywords

    perform_scraper
    true
  rescue StandardError
    false
  end

  def preview
    return keywords unless valid?

    parse_keywords
    keywords
  end

  private

  def save_keywords
    ActiveRecord::Base.transaction do
      user_order = current_user.user_orders.create(content: keywords.join(', '))
      new_keywords = keywords.map { |content| { user_order_id: user_order.id, content: content } }
      @keyword_ids = user_order.keywords.insert_all(new_keywords).pluck('id')
    end
    true
  rescue ActiveRecord::StatementInvalid, ArgumentError
    errors.add(:base, 'Error StatementInvalid')
    false
  end

  def parse_keywords
    @keywords = CSV.read(file.tempfile).flatten.uniq.compact.reject(&:empty?).uniq
  rescue StandardError => e
    errors.add(:base, e.message)
    @keywords = []
  end

  def perform_scraper
    keyword_ids.compact.each_with_index do |keyword_id, index|
      jid = KeywordScraperJob.perform_in((index * JOB_INTERVAL).seconds, keyword_id)
      @jids << jid
    end
    Rails.logger.debug { "enqueue job #{@jids}, keyword: #{keyword_idss}" } unless Rails.env.test?
  end
end
