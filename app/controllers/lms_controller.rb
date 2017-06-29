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
      '06E777CD-1DC2-1CDA-6A8E-68B94E413201',
      '825d81462ec90220f734af6c6bac5a0e88253d1fa83fb6daecd4f897968bfbdf',
      site: 'https://bazaar.samposoftware.com/'
    )
    access_token = client.password.get_token('shaliko.usubov@samposoftware.com', '123456')
    session[:token] = access_token.token
  end
end
