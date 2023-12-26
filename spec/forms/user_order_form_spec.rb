require 'rails_helper'
require 'sidekiq/testing'

RSpec.describe UserOrderForm do
  let(:user) { create(:user) }
  let(:single_record) { fixture_file_upload('/csv/single.csv', 'text/csv') }
  let(:too_long) { fixture_file_upload('/csv/too_long.csv', 'text/csv') }
  let(:hundred_records) { fixture_file_upload('/csv/full.csv', 'text/csv') }
  let(:many_records) { fixture_file_upload('/csv/many.csv', 'text/csv') }
  let(:text_file) { fixture_file_upload('/csv/text.txt', 'text/txt') }

  before do
    Sidekiq::Testing.fake!
  end

  after do
    Sidekiq::Testing.inline!
  end

  describe '#validate' do
    context 'with valid parameters' do
      context 'with 1 keyword' do
        let(:user_order) { described_class.new(user, single_record) }
        it 'valid? is true' do
          expect(user_order.valid?).to be(true)
        end
      end

      context 'with 100 keywords' do
        let(:user_order) { described_class.new(user, hundred_records) }
        it 'valid? is true' do
          expect(user_order.valid?).to be(true)
        end
      end
    end

    context 'with invalid parameters' do
      context 'incorrect file is nil' do
        let(:user_order) { described_class.new(user, nil) }
        it 'have status false with errors' do
          expect(user_order.valid?).to be(false)
          expect(user_order.errors[:base][0]).to eq('File is required')
        end
      end

      context 'incorrect file type' do
        let(:user_order) { described_class.new(user, text_file) }
        it 'have status false with errors' do
          expect(user_order.valid?).to be(false)
          expect(user_order.errors[:base][0]).to eq('File type should be valid CSV')
        end
      end

      context 'with too many keywords' do
        let(:user_order) { described_class.new(user, many_records) }
        it 'have status false with errors' do
          expect(user_order.valid?).to be(false)
          expect(user_order.errors[:base][0]).to eq('Total keywords must be between 1 and 100')
        end
      end
    end
  end

  describe '#save' do
    context 'with valid parameters' do
      let(:user_order) { described_class.new(user, hundred_records) }
      it 'have status true with keyword_ids' do
        user_order.save
        expect(user_order.valid?).to be(true)
        expect(user_order.keyword_ids.count).to eq(100)
        expect(user_order.keywords.count).to eq(100)
      end
    end

    context 'with invalid parameters' do
      let(:user_order) { described_class.new(user, many_records) }
      it 'have status false with errors' do
        user_order.save
        expect(user_order.valid?).to be(false)
        expect(user_order.errors[:base][0]).to eq('Total keywords must be between 1 and 100')
        expect(user_order.keyword_ids.count).to be(0)
        expect(user_order.keywords.count).to eq(0)
      end
    end
  end

  describe '#preview' do
    context 'with valid parameters' do
      let(:user_order) { described_class.new(user, hundred_records) }
      it 'return keyword list' do
        user_order.preview
        expect(user_order.keywords.count).to eq(100)
      end
    end

    context 'with invalid parameters' do
      let(:user_order) { described_class.new(user, text_file) }
      it 'return blank keyword list ' do
        user_order.preview
        expect(user_order.keywords.count).to eq(0)
      end
    end
  end
end
