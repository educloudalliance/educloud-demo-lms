class PagesController < ApplicationController
  include PagesJson

  before_action :access_token, only: %i[browse view]

  def index; end

  def browse
    params = {
      access_token: session[:token],
      cancel_url: root_url,
      add_resource_callback_url: pages_url
    }

    response = HTTParty.post('http://educloud.dev/api/v1/lms/browse', saml_attributes_to_json(params))

    return if response_401?(response.headers['status'])

    redirect_to(JSON.parse(response.body)['browse_url'])
  end

  def view
    params = { access_token: session[:token] }
    response = HTTParty.post('http://educloud.dev/api/v1/lms/view', saml_attributes_to_json(params))

    @response = if response_401?(response.headers['status'])
      response.headers['status']
    else
      JSON.parse(response.body)
    end
  end

  def create
    @response = JSON.parse params[:params]
  end
end
