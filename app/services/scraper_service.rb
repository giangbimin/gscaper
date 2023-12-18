class ScraperService < ApplicationService
  SEARCH_URL = 'https://www.google.com/search'.freeze

  # rubocop:disable Layout/LineLength
  USER_AGENTS = [
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.3	17.34',
    'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_6) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.1.2 Safari/605.1.1	11.27',
    'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Safari/605.1.1	9.83',
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.3	9.25',
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:120.0) Gecko/20100101 Firefox/120.	6.94',
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:109.0) Gecko/20100101 Firefox/117.	2.31',
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36 Edg/119.0.0.	2.31',
    'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.3	1.16',
    'Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:109.0) Gecko/20100101 Firefox/115.	1.16',
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/86.0.4240.198 Safari/537.3	1.16',
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36 OPR/106.0.0.0 (Edition beta	1.16',
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36 Herring/90.1.9310.1	1.16',
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36 OPR/105.0.0.	1.16',
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/117.0.0.0 Safari/537.36 Edg/117.0.2045.4	1.16',
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.3	1.16'
  ].freeze
  # rubocop:enable Layout/LineLength

  TEMPLATE = {
    total_result: 'div#result-stats',
    total_link: 'a',
    total_ad: 'div[data-text-ad]'
  }.freeze

  NUMBER_TEMPLATE = /(\d+(\.\d+)*)/.freeze

  attr_reader :keyword

  def initialize(keyword)
    @keyword = keyword
    @url = "#{SEARCH_URL}?q=#{CGI.escape(keyword)}"
    super
  end

  def execute
    validate
    return unless status

    search
    return unless status

    parse
  end

  private

  def validate
    errors[:base] = 'keyword blank' if keyword.blank?
  end

  def search
    response = HTTParty.get(URI(@url), headers: { 'User-Agent' => USER_AGENTS.sample })
    if response.success?
      @html_body = response.body
      return
    end
    errors[:network] = "Error: #{response.code}"
  rescue StandardError => e
    errors[:base] = e.message
  end

  def parse
    @document = Nokogiri::HTML.parse(@html_body)
    {
      total_link: total_link,
      total_result: total_result,
      total_ad: total_ad,
      html_code: @html_body
    }
  end

  def total_result
    @document.css(TEMPLATE[:total_result]).text.match(NUMBER_TEMPLATE)[1].gsub('.', '').to_i
  end

  def total_link
    @document.css(TEMPLATE[:total_link])&.count.to_i
  end

  def total_ad
    @document.css(TEMPLATE[:total_ad])&.count.to_i
  end
end
