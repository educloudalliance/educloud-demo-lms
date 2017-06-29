class LmsController < ApplicationController
  before_action :access_token, only: %i[index]

  def index; end

  def create
    @response = JSON.parse params[:params]
  end

  private

  def access_token
    return if session[:token].present?
    client = OAuth2::Client.new(
      ENV['OAUTH_CLIENT_ID'],
      ENV['OAUTH_CLIENT_SECRET'],
      site: 'https://bazaar.samposoftware.com/'
    )

    access_token = client.password.get_token(ENV['BAZAAR_USER_EMAIL'], ENV['BAZAAR_USER_PASSWORD'])
    session[:token] = access_token.token
  end
end
