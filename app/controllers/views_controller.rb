class ViewsController < ApplicationController
  def index
    params = { access_token: session[:token] }
    response = HTTParty.post('http://educloud.dev/api/v1/lms/view', saml_attributes_to_json(params))

    @response = if response_401?(response.headers['status'])
      response.headers['status']
    else
      JSON.parse(response.body)
    end
  end
end
