require 'rails_helper'

RSpec.describe KeywordsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/keywords').to route_to('keywords#index')
    end

    it 'routes to #new' do
      expect(get: '/keywords/new').to route_to('keywords#new')
    end

    it 'routes to #show' do
      expect(get: '/keywords/1').to route_to('keywords#show', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/keywords').to route_to('keywords#create')
    end
  end
end
