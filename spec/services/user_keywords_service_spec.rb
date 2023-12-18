require 'rails_helper'
require 'sidekiq/testing'

RSpec.describe UserKeywordsService, type: :model do
  before do
    Sidekiq::Testing.fake!
  end

  after do
    Sidekiq::Testing.inline!
  end

  describe '#execute' do
    let(:user) { create(:user) }
    let(:many_records) { fixture_file_upload('/csv/many.csv', 'text/csv') }
    let(:sample) { fixture_file_upload('/csv/sample.csv', 'text/csv') }

    context 'with invalid file input' do
      it 'status is false with errors messages' do
        service = UserKeywordsService.new(user, many_records)
        service.execute
        expect(service.status).to be(false)
        expect(service.errors[:base]).to eq('Total keywords must between 1 and 100')
        expect(Keyword.count).to eq(0)
        expect(UserKeyword.count).to eq(0)
      end
    end

    context 'with valid data input' do
      context 'with unique keyword' do
        before do
          first_keyword = create(:keyword, content: 'aws')
          create(:user_keyword, user: user, keyword: first_keyword)
          second_keyword = create(:keyword, content: 'firebase')
          create(:user_keyword, user: user, keyword: second_keyword)
          create(:keyword, content: 'reddit')
        end

        it 'status is true with then create keywords' do
          service = UserKeywordsService.new(user, sample)
          service.execute
          expect(service.status).to be(true)
          expect(Keyword.count).to eq(6)
          expect(UserKeyword.count).to eq(5)
        end
      end

      context 'with duplicated keywords' do
        before do
          first_keyword = create(:keyword, content: 'google')
          create(:user_keyword, user: user, keyword: first_keyword)
          create(:keyword, content: 'facebook')
          third_keyword = create(:keyword, content: 'reddit')
          create(:user_keyword, user: user, keyword: third_keyword)
        end

        it 'status is true with then create non duplicated keywords' do
          service = UserKeywordsService.new(user, sample)
          service.execute
          expect(service.status).to be(true)
          expect(Keyword.count).to eq(4)
          expect(UserKeyword.count).to eq(4)
        end
      end

      context 'with duplicated user_keyword' do
        before do
          first_keyword = create(:keyword, content: 'google')
          create(:user_keyword, user: user, keyword: first_keyword)
          second_keyword = create(:keyword, content: 'facebook')
          create(:user_keyword, user: user, keyword: second_keyword)
          create(:keyword, content: 'reddit')
        end

        it 'status is true with then create non duplicated keywords' do
          service = UserKeywordsService.new(user, sample)
          service.execute
          expect(service.status).to be(true)
          expect(Keyword.count).to eq(4)
          expect(UserKeyword.count).to eq(3)
        end
      end
    end
  end
end
