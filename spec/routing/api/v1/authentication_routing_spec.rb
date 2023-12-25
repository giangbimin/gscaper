require 'rails_helper'

RSpec.describe Api::AuthenticationController, type: :routing do
  describe 'routing' do
    it 'routes to #sign_in' do
      expect(post: '/api/sign_in').to route_to('api/authentication#sign_in')
    end

    it 'routes to #refresh' do
      expect(post: '/api/refresh').to route_to('api/authentication#refresh')
    end

    it 'routes to #sign_out' do
      expect(post: '/api/sign_out').to route_to('api/authentication#sign_out')
    end
  end
end
