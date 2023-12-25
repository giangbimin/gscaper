require 'rails_helper'

RSpec.describe Api::V1::KeywordsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/api/v1/keywords').to route_to('api/v1/keywords#index')
    end

    it 'routes to #show' do
      expect(get: '/api/v1/keywords/1').to route_to('api/v1/keywords#show', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/api/v1/keywords').to route_to('api/v1/keywords#create')
    end
  end
end
