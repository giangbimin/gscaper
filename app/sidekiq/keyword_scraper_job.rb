class KeywordScraperJob
  include Sidekiq::Job

  def perform(keyword_id)
    service = Job::KeywordScraperService.new(keyword_id)
    service.execute
    logger.error(service.errors) unless service.status
  end
end
