# spec/services/job/keyword_scraper_service_spec.rb
require 'rails_helper'

RSpec.describe Job::KeywordScraperService, type: :service do
  let(:content) { 'google' }
  let(:keyword) { create(:keyword, content: content) }
  let(:body) { file_fixture('/http/google.txt') }
  let(:scraper_service_response) { { total_link: 78, total_result: 25_270_000_000, total_ad: 0, html_code: body.read } }
  let(:processed) { false }

  describe '#initialize' do
    it 'initializes errors as an empty hash' do
      service = described_class.new(keyword.id)
      expect(service.errors).to be_empty
    end
  end

  describe '#execute' do
    subject(:service) { described_class.new(keyword.id) }
    subject(:execute_service) { service.call }

    context 'when the keyword is found and not processed' do
      before do
        allow(ScraperService).to receive_message_chain(:new, :execute).and_return(scraper_service_response)
        allow(ScraperService).to receive_message_chain(:new, :status).and_return(true)
      end
      it 'calls find_keyword, scraping, and update_keyword' do
        execute_service
        expect(service.status).to eq(true)
        updated_keyword = keyword.reload
        expect(updated_keyword.status).to eq('processed')
        expect(updated_keyword.total_link).to eq(scraper_service_response[:total_link])
        expect(updated_keyword.total_result).to eq(scraper_service_response[:total_result])
        expect(updated_keyword.total_ad).to eq(scraper_service_response[:total_ad])
        expect(updated_keyword.html_code).to eq(scraper_service_response[:html_code])
      end
    end

    context 'when the keyword is not found' do
      before do
        allow(Keyword).to receive(:find_by).with(id: keyword.id).and_return(nil)
      end

      it 'sets an error message' do
        execute_service
        expect(service.errors[:base]).to eq('keyword not found')
      end
    end

    context 'when the keyword is already processed' do
      let(:keyword) { create(:keyword, content: content, status: :processed) }

      it 'does not call scraping and update_keyword' do
        execute_service
        expect(service.status).to eq(true)
      end
    end

    context 'when the keyword is already processed but force refresh' do
      let(:keyword) { create(:keyword, content: content, status: :processed) }
      before do
        allow(ScraperService).to receive_message_chain(:new, :execute).and_return(scraper_service_response)
        allow(ScraperService).to receive_message_chain(:new, :status).and_return(true)
      end

      it 'does not call scraping and update_keyword' do
        service.force_refresh = true
        execute_service
        expect(service.status).to eq(true)
      end
    end

    context 'when an exception occurs during scraping' do
      before do
        allow(ScraperService).to receive_message_chain(:new, :execute).and_raise(StandardError, 'Some error')
      end

      it 'sets an error message' do
        execute_service
        expect(service.errors[:base]).to eq('Some error')
        updated_keyword = keyword.reload
        expect(updated_keyword.status).to eq('failed')
      end
    end
  end
end
