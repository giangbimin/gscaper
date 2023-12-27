# spec/services/scraper_service_spec.rb
require 'rails_helper'

RSpec.describe ScraperService, type: :service do
  # let(:body) { file_fixture('/http/google.txt') }
  let(:keyword) { 'google' }

  describe '#initialize' do
    let(:service) { described_class.new(keyword) }
    it 'initializes errors as an empty hash' do
      expect(service.errors).to be_empty
    end

    it 'sets the keyword and URL' do
      expect(service.keyword).to eq(keyword)
      expect(service.instance_variable_get(:@url)).to eq("https://www.google.com/search?q=#{CGI.escape(keyword)}")
    end
  end

  describe '#execute' do
    context 'when the keyword is blank' do
      it 'sets an error message' do
        service = described_class.new('')
        execute_service = service.call
        expect(execute_service).to be_nil
        expect(service.status).to eq(false)
        expect(service.errors[:base]).to eq('keyword blank')
      end
    end

    context 'when the request is successful' do
      let(:service) { described_class.new(keyword) }
      # before do
      #   stub_request(:get, "https://www.google.com/search?q=#{keyword}")
      #     .to_return(status: 200, body: body, headers: {})
      # end

      it 'calls search and parse methods' do
        execute_service = VCR.use_cassette keyword, record: :once do
          service.call
        end
        expect(service.status).to eq(true)
        expect(execute_service[:total_result] >= 0).to be(true)
        expect(execute_service[:total_link] >= 0).to be(true)
        expect(execute_service[:total_ad] >= 0).to be(true)
        expect(execute_service[:html_code].present?).to be(true)
      end
    end

    context 'when the request is unsuccessful' do
      let(:service) { described_class.new(keyword) }
      before do
        stub_request(:get, "https://www.google.com/search?q=#{keyword}")
          .to_return(status: 500, body: 'Internal Server Error', headers: {})
      end

      it 'sets an error message' do
        execute_service = service.call
        expect(execute_service).to be_nil
        expect(service.status).to eq(false)
        expect(service.errors[:network]).to eq('Error: 500')
      end
    end

    context 'when an exception occurs during the request' do
      let(:service) { described_class.new(keyword) }
      before do
        allow(HTTParty).to receive(:get).and_raise(StandardError, 'Some error')
      end

      it 'sets an error message' do
        execute_service = service.call
        expect(execute_service).to be_nil
        expect(service.status).to eq(false)
        expect(service.errors[:base]).to eq('Some error')
      end
    end
  end
end
