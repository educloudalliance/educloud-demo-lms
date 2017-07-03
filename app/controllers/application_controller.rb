class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session

  def response_401?(status_str)
    status_str.include? '401'
  end

  def saml_attributes_to_json(params)
    session[:attributes].each { |k, v| params[k] = v[0] }
    params
  end
end
