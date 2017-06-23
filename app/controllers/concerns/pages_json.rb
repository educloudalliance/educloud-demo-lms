module PagesJson
  def access_token
    # http://educloud.dev/oauth/applications
    return if session[:token].present?
    client = OAuth2::Client.new(
      'bafe385a120f17a23847d65d3651905cd471e7a398f2e38b1c42ab886c2d1583',
      'c9cf1c4b64c8f8caac64b7b62b65b8bef78aa184826e18b595151f847af4f806',
      site: 'http://localhost'
    )
    access_token = client.password.get_token('carl@bazaar.com', '123456')
    session[:token] = access_token.token
  end

  def response_401?(status_str)
    status_str.include? '401'
  end

  def saml_attributes_to_json(params)
    session[:attributes].each { |k, v| params[k] = v[0] }
    {
      body: params.to_json,
      headers: {
        'Content-Type' => 'application/json'
      }
    }
  end
end
