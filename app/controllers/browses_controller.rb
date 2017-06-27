class BrowsesController < ApplicationController
  def index
    params = {
      access_token: session[:token],
      cancel_url: lms_url,
      add_resource_callback_url: lms_url
    }

    response = HTTParty.post('http://educloud.dev/api/v1/lms/browse', saml_attributes_to_json(params))

    return if response_401?(response.headers['status'])

    redirect_to(JSON.parse(response.body)['browse_url'])
  end
end
