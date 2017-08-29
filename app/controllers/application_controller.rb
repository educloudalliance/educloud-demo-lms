class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def response_401?(status_str)
    status_str.include? '401'
  end

  def saml_attributes_to_json(params)
    template = {
      'org:OID' => 'oid', 'org:role' => 'role', 'id:uid' => 'user_id',
      'org:school' => 'school', 'id:school' => 'school_id',
      'org:municipality' => 'city', 'id:municipalityCode' => 'city_id'
    }
    session[:attributes].each do |key, value|
      splitkey = key.split('.').last
      params[template[splitkey]] = value[0] if template.include? splitkey
    end
    params
  end
end
