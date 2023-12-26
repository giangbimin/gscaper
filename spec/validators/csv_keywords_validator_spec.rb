require 'rails_helper'

RSpec.describe CsvKeywordsValidator do
  let(:user) { create(:user) }
  let(:single_record) { fixture_file_upload('/csv/single.csv', 'text/csv') }
  let(:too_long) { fixture_file_upload('/csv/too_long.csv', 'text/csv') }
  let(:hundred_records) { fixture_file_upload('/csv/full.csv', 'text/csv') }
  let(:many_records) { fixture_file_upload('/csv/many.csv', 'text/csv') }
  let(:text_file) { fixture_file_upload('/csv/text.txt', 'text/txt') }

  describe '#validation' do
    context 'with valid parameters' do
      context 'with 1 keyword' do
        let(:user_order) { UserOrderForm.new(user, single_record) }
        it 'valid? is true' do
          validator = described_class.new
          validator.validate(user_order)
          expect(validator.user_order.valid?).to be(true)
        end
      end

      context 'with 100 keywords' do
        let(:user_order) { UserOrderForm.new(user, hundred_records) }
        it 'valid? is true' do
          validator = described_class.new
          validator.validate(user_order)
          expect(validator.user_order.valid?).to be(true)
        end
      end
    end

    context 'with invalid parameters' do
      context 'incorrect file is nil' do
        let(:user_order) { UserOrderForm.new(user, nil) }
        it 'have status false with errors' do
          validator = described_class.new
          validator.validate(user_order)
          expect(validator.user_order.valid?).to be(false)
          expect(validator.user_order.errors[:base][0]).to eq('File is required')
        end
      end

      context 'incorrect file type' do
        let(:user_order) { UserOrderForm.new(user, text_file) }
        it 'have status false with errors' do
          validator = described_class.new
          validator.validate(user_order)
          expect(validator.user_order.valid?).to be(false)
          expect(validator.user_order.errors[:base][0]).to eq('File type should be valid CSV')
        end
      end

      context 'with too many keywords' do
        let(:user_order) { UserOrderForm.new(user, many_records) }
        it 'have status false with errors' do
          validator = described_class.new
          validator.validate(user_order)
          expect(validator.user_order.valid?).to be(false)
          expect(validator.user_order.errors[:base][0]).to eq('Total keywords must be between 1 and 100')
        end
      end
    end
  end
end
