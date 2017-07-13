class Account < ActiveRecord::Base
  def self.get_saml_settings(url_base)
    # this is just for testing purposes.
    # should retrieve SAML-settings based on subdomain, IP-address, NameID or similar
    settings = OneLogin::RubySaml::Settings.new

    # Example settings data, replace this values!

    # When disabled, saml validation errors will raise an exception.
    settings.soft = true

    # SP section
    settings.issuer = url_base + '/saml/metadata'
    settings.assertion_consumer_service_url = url_base + '/saml/acs'
    settings.assertion_consumer_logout_service_url = url_base + '/saml/logout'

    # IdP section
    idp_section(settings)

    # settings.name_identifier_format = 'urn:oasis:names:tc:SAML:2.0:nameid-format:emailAddress'

    # Security section
    settings.security[:authn_requests_signed] = true
    settings.security[:logout_requests_signed] = false
    settings.security[:logout_responses_signed] = false
    settings.security[:metadata_signed] = true
    settings.security[:digest_method] = XMLSecurity::Document::SHA1
    settings.security[:signature_method] = XMLSecurity::Document::RSA_SHA1

    settings
  end

  def self.idp_section(settings)
    settings.idp_sso_target_url = ENV['IDP_SSO_TARGET_URL']
    settings.idp_cert = ENV['IDP_CERT']
  end
end
