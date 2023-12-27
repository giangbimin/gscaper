module Job
  class KeywordScraperService < ApplicationService
    attr_reader :keyword, :scraper_response
    attr_accessor :force_refresh

    def initialize(keyword_id)
      @keyword_id = keyword_id
      super
    end

    def call
      find_keyword
      return unless status
      return if keyword.processed_status? && !force_refresh

      scraping
      update_keyword
    end

    private

    def find_keyword
      @keyword = Keyword.find_by(id: @keyword_id)
      errors[:base] = 'keyword not found' unless keyword
    end

    def scraping
      scraper = ScraperService.new(keyword.content)
      @scraper_response = scraper.call
      errors.merge!(scraper.errors) unless scraper.status
    rescue StandardError => e
      errors[:base] = e.message
      nil
    end

    def update_keyword
      if scraper_response.present?
        keyword.update(scraper_response.merge({ status: :processed }))
        return
      end
      keyword.update(status: :failed)
    rescue StandardError => e
      errors[:base] = e.message
    end
  end
end
