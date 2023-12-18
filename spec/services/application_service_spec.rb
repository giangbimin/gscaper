# spec/services/application_service_spec.rb
require 'rails_helper'

RSpec.describe ApplicationService do
  let(:service) { described_class.new }

  describe '#initialize' do
    it 'initializes errors as an empty hash' do
      expect(service.errors).to be_empty
    end
  end

  describe '#status' do
    it 'returns true if errors are blank' do
      expect(service.status).to be_truthy
    end

    it 'returns false if errors are present' do
      service.errors[:base] = 'Some error' # rubocop:disable Rails/DeprecatedActiveModelErrorsMethods
      expect(service.status).to be_falsey
    end
  end
end
