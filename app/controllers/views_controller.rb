class ViewsController < ApplicationController
  def index
    params = { access_token: session[:token], resource_uid: 'f548d3871cf23b87807208bd447d89c8' }
    response = RestClient.post "#{ENV['BAZAAR_API_URL']}/lms/view", saml_attributes_to_json(params)

    @response = JSON.parse(response.body)
  end
end
