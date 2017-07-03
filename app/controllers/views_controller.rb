class ViewsController < ApplicationController
  def index
    params = { access_token: session[:token] }
    response = RestClient.post "#{ENV['BAZAAR_API_URL']}/lms/view", saml_attributes_to_json(params)

    @response = JSON.parse(response.body)
  end
end
