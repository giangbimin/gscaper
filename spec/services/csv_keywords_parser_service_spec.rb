require 'rails_helper'

RSpec.describe CsvKeywordsParserService do
  describe '#execute' do
    let(:single_record) { fixture_file_upload('/csv/single.csv', 'text/csv') }
    let(:too_long) { fixture_file_upload('/csv/too_long.csv', 'text/csv') }
    let(:hundred_records) { fixture_file_upload('/csv/full.csv', 'text/csv') }
    let(:many_records) { fixture_file_upload('/csv/many.csv', 'text/csv') }
    let(:text_file) { fixture_file_upload('/csv/text.txt', 'text/txt') }

    context 'with valid parameters' do
      context 'with 1 keyword' do
        it 'return list of keywords' do
          service = CsvKeywordsParserService.new(single_record)
          keywords = service.execute
          expect(keywords.count).to eq(1)
          expect(service.status).to be(true)
        end
      end
      context 'with 100 keywords' do
        it 'return list of keywords' do
          service = CsvKeywordsParserService.new(hundred_records)
          keywords = service.execute
          expect(keywords.count).to eq(100)
          expect(service.status).to be(true)
        end
      end
    end

    context 'with invalid parameters' do
      context 'incorrect file is nil' do
        it 'have status false with errors' do
          service = CsvKeywordsParserService.new(nil)
          keywords = service.execute
          expect(keywords.count).to eq(0)
          expect(service.status).to be(false)
          expect(service.errors[:base]).to eq('File is required')
        end
      end

      context 'incorrect file type' do
        it 'have status false with errors' do
          service = CsvKeywordsParserService.new(text_file)
          keywords = service.execute
          expect(keywords.count).to eq(0)
          expect(service.status).to be(false)
          expect(service.errors[:base]).to eq('File type should be valid CSV')
        end
      end

      context 'with too many keywords' do
        it 'have status false with errors' do
          service = CsvKeywordsParserService.new(many_records)
          keywords = service.execute
          expect(keywords.count).to eq(0)
          expect(service.status).to be(false)
          expect(service.errors[:base]).to eq('Total keywords must between 1 and 100')
        end
      end

      # context 'with keyword too long' do
      #   it 'have status false with errors' do
      #     service = CsvKeywordsParserService.new(too_long)
      #     keywords = service.execute
      #     expect(keywords.count).to eq(0)
      #     expect(service.status).to be(false)
      #     expect(service.errors[:base]).to eq('keyword number 0 is too long')
      #   end
      # end
    end
  end
end
