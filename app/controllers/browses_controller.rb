class BrowsesController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    params = {
      access_token: session[:token],
      cancel_url: lms_url,
      add_resource_callback_url: lms_url
    }

    response = RestClient.post "#{ENV['BAZAAR_API_URL']}/lms/browse", saml_attributes_to_json(params)

    redirect_to(JSON.parse(response.body)['browse_url'])
  end
end
