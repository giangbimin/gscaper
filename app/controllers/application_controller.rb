class ApplicationController < ActionController::Base
  include Pagy::Backend

  before_action :authenticate_user!

  layout :determine_layout

  def determine_layout
    devise_controller? ? 'unauthenticated' : 'application'
  end
end
