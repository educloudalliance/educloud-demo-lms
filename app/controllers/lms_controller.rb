class LmsController < ApplicationController
  before_action :access_token, only: %i[index]

  def index; end

  def create
    @response = JSON.parse params[:params]
  end

  private

  def access_token
    return if session[:token].present?
    response = RestClient.post 'https://bazaar.educloudalliance.org/oauth/token',
      grant_type: 'client_credentials',
      client_id: ENV['OAUTH_CLIENT_ID'],
      client_secret: ENV['OAUTH_CLIENT_SECRET']

    access_token = JSON.parse(response)['access_token']
    session[:token] = access_token
  end
end
