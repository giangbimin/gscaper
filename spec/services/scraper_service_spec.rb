# spec/services/scraper_service_spec.rb
require 'rails_helper'

RSpec.describe ScraperService, type: :service do
  let(:keyword) { 'google' }
  let(:scraper_service) { described_class.new(keyword) }
  let(:body) { file_fixture('/http/google.txt') }

  describe '#initialize' do
    it 'initializes errors as an empty hash' do
      expect(scraper_service.errors).to be_empty
    end

    it 'sets the keyword and URL' do
      expect(scraper_service.keyword).to eq(keyword)
      expect(scraper_service.instance_variable_get(:@url)).to eq("https://www.google.com/search?q=#{CGI.escape(keyword)}")
    end
  end

  describe '#execute' do
    subject(:service) { described_class.new(keyword) }
    subject(:execute_service) { service.call }

    context 'when the keyword is blank' do
      let(:keyword) { '' }

      it 'sets an error message' do
        expect(execute_service).to be_nil
        expect(service.status).to eq(false)
        expect(service.errors[:base]).to eq('keyword blank')
      end
    end

    context 'when the request is successful' do
      let(:keyword) { 'google' }
      before do
        stub_request(:get, "https://www.google.com/search?q=#{keyword}")
          .to_return(status: 200, body: body, headers: {})
      end

      it 'calls search and parse methods' do
        expect(service.status).to eq(true)
        expect(execute_service[:total_result]).to eq(25_270_000_000)
        expect(execute_service[:total_link]).to eq(78)
        expect(execute_service[:total_ad]).to eq(0)
        expect(execute_service[:html_code]).to eq(body.read)
      end
    end

    context 'when the request is unsuccessful' do
      let(:keyword) { 'google' }
      before do
        stub_request(:get, "https://www.google.com/search?q=#{keyword}")
          .to_return(status: 500, body: 'Internal Server Error', headers: {})
      end

      it 'sets an error message' do
        expect(execute_service).to be_nil
        expect(service.status).to eq(false)
        expect(service.errors[:network]).to eq('Error: 500')
      end
    end

    context 'when an exception occurs during the request' do
      before do
        allow(HTTParty).to receive(:get).and_raise(StandardError, 'Some error')
      end

      it 'sets an error message' do
        expect(execute_service).to be_nil
        expect(service.status).to eq(false)
        expect(service.errors[:base]).to eq('Some error')
      end
    end
  end
end
