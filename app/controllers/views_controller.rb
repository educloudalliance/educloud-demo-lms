class ViewsController < ApplicationController
  def index
    params = { access_token: session[:token] }
    response = HTTParty.post('https://bazaar.samposoftware.com/api/v1/lms/view', saml_attributes_to_json(params))

    @response = JSON.parse(response.body)
  end
end
