class Account < ActiveRecord::Base
  def self.get_saml_settings(url_base)
    # this is just for testing purposes.
    # should retrieve SAML-settings based on subdomain, IP-address, NameID or similar
    settings = OneLogin::RubySaml::Settings.new

    url_base ||= 'http://localhost:8080'

    # Example settings data, replace this values!

    # When disabled, saml validation errors will raise an exception.
    settings.soft = true

    # SP section
    settings.issuer = url_base + '/saml/metadata'
    settings.assertion_consumer_service_url = url_base + '/saml/acs'
    settings.assertion_consumer_logout_service_url = url_base + '/saml/logout'

    # IdP section
    idp_section(settings)

    # settings.name_identifier_format = 'urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress'
    settings.name_identifier_format = 'urn:oasis:names:tc:SAML:2.0:nameid-format:emailAddress'

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
    settings.idp_entity_id = 'https://app.onelogin.com/saml/metadata/654913'
    settings.idp_sso_target_url = 'https://app.onelogin.com/trust/saml2/http-post/sso/654913'
    settings.idp_slo_target_url = 'https://app.onelogin.com/trust/saml2/http-redirect/slo/654913'
    settings.idp_cert = "-----BEGIN CERTIFICATE-----
MIIECzCCAvOgAwIBAgIUTxRkWe+PRomTKWhQCFpgwg1/8zMwDQYJKoZIhvcNAQEF
BQAwVDELMAkGA1UEBhMCVVMxDDAKBgNVBAoMA2dvZDEVMBMGA1UECwwMT25lTG9n
aW4gSWRQMSAwHgYDVQQDDBdPbmVMb2dpbiBBY2NvdW50IDEwNDY0OTAeFw0xNzA0
MTExNDA2MDdaFw0yMjA0MTIxNDA2MDdaMFQxCzAJBgNVBAYTAlVTMQwwCgYDVQQK
DANnb2QxFTATBgNVBAsMDE9uZUxvZ2luIElkUDEgMB4GA1UEAwwXT25lTG9naW4g
QWNjb3VudCAxMDQ2NDkwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCx
6nufHb5N5N3NVlvDKLqGXvUZZMRWlTIGKkl7ANLLGZ1wdXDIS2St/MttqDNs6wGn
RSZ1n14nhiXY8Bh0S1iwnx+AxKgA9iS7pnEArU/QdXLyA2tvD0Zy2bOyQyWb7eTN
SNihCj9XlmHiGS9gAlx4P/5mN1dSzPHAk/VbxCXtUxA4xOeSEpLbffQe0HSlY/Yo
5xHzMPapIKOpHAyLj3BMxRJZGl4WBXwBUcAI6rkQq104iKO/hEmTP0eGDY8JTHPJ
3BOG+kvgg7uHskjBnO+etwaiGDYmRQQFqT+2IhD154PF73WJGroPQkAP52wDUeCv
3Wh/qbn+sutXsGIj6hhNAgMBAAGjgdQwgdEwDAYDVR0TAQH/BAIwADAdBgNVHQ4E
FgQU1TRlIJQ83xgV6/KbEIbFMUggROgwgZEGA1UdIwSBiTCBhoAU1TRlIJQ83xgV
6/KbEIbFMUggROihWKRWMFQxCzAJBgNVBAYTAlVTMQwwCgYDVQQKDANnb2QxFTAT
BgNVBAsMDE9uZUxvZ2luIElkUDEgMB4GA1UEAwwXT25lTG9naW4gQWNjb3VudCAx
MDQ2NDmCFE8UZFnvj0aJkyloUAhaYMINf/MzMA4GA1UdDwEB/wQEAwIHgDANBgkq
hkiG9w0BAQUFAAOCAQEAizN1cLe9nG48erkyaYkk2/oAyGr26iLLLW7sxs8JZZiy
8gIvfIeVn4IjdOLf4gTciDjhTcPKGODGaM6Wj8drXCY+bVHBm1BRhJW8brR4Z19W
LGCAKCxARg1/sLjNJXcE6CZeJ6BD2AWaUHOIDzxesWQUNhKYPsBbOZFs+Fl6uBow
VZPQ9Ffd9Qx1sR4G5jKxf1gchsDYcOVfnrITujVbWb/tULdYPF0AI/ZW4R/fhlFo
Mrd/Pcgw7ibyhc/8BmU+B4uTiRQ18nu7yKUItD9tva9rVT8/s+JEKIGTqSsoJ/RX
SUqB9fwIEKfyFEHhB8wS0OUz8VhX6hZIztF36jdhaA==
 ------END CERTIFICATE-----"
    # or settings.idp_cert_fingerprint           = "3B:05:BE:0A:EC:84:CC:D4:75:97:B3:A2:22:AC:56:21:44:EF:59:E6"
    #    settings.idp_cert_fingerprint_algorithm = XMLSecurity::Document::SHA1
  end
end