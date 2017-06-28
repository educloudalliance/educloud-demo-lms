class LmsController < ApplicationController
  before_action :access_token, only: %i[index]

  def index; end

  def create
    @response = JSON.parse params[:params]
  end

  private

  def access_token
    # http://educloud.dev/oauth/applications
    return if session[:token].present?
    client = OAuth2::Client.new(
      'bafe385a120f17a23847d65d3651905cd471e7a398f2e38b1c42ab886c2d1583',
      'c9cf1c4b64c8f8caac64b7b62b65b8bef78aa184826e18b595151f847af4f806',
      site: 'http://localhost'
    )
    access_token = client.password.get_token('carl@bazaar.com', '123456')
    session[:token] = access_token.token
  end
end
