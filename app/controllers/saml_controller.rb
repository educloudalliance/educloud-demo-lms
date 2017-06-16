class SamlController < ApplicationController
  skip_before_action :verify_authenticity_token, only: %i[acs logout]

  def index
    @attrs = {}
  end

  def sso
    settings = Account.get_saml_settings(url_base)
    if settings.nil?
      render action: :no_settings
      return
    end

    request = OneLogin::RubySaml::Authrequest.new
    redirect_to(request.create(settings))
  end

  def acs
    settings = Account.get_saml_settings(url_base)
    response = OneLogin::RubySaml::Response.new(params[:SAMLResponse], settings: settings)

    if response.is_valid?
      session[:nameid] = response.nameid
      session[:attributes] = response.attributes
      # @attrs = session[:attributes]
      # logger.info 'Sucessfully logged'
      # logger.info "NAMEID: #{response.nameid}"
      # render :action => :index
      # create_cart_when_login
      redirect_to pages_path
    else
      # logger.info "Response Invalid. Errors: #{response.errors}"
      @errors = response.errors
      render action: :fail
    end
  end

  # def create_cart_when_login
  #   cart = ShoppingCart.create
  #   session[:shopping_cart_id] = cart.id
  # end

  def metadata
    settings = Account.get_saml_settings(url_base)
    meta = OneLogin::RubySaml::Metadata.new
    render xml: meta.generate(settings, true)
  end

  # Trigger SP and IdP initiated Logout requests
  def logout
    # If we're given a logout request, handle it in the IdP logout initiated method
    if params[:SAMLRequest]
      idp_logout_request
      # We've been given a response back from the IdP
    elsif params[:SAMLResponse]
      process_logout_response
    elsif params[:slo]
      sp_logout_request
    else
      reset_session
    end
  end

  # Create an SP initiated SLO
  def sp_logout_request
    # LogoutRequest accepts plain browser requests w/o paramters
    settings = Account.get_saml_settings(url_base)

    if settings.idp_slo_target_url.nil?
      # logger.info 'SLO IdP Endpoint not found in settings, executing then a normal logout'
      reset_session
    else

      # Since we created a new SAML request, save the transaction_id
      # to compare it with the response we get back
      logout_request = OneLogin::RubySaml::Logoutrequest.new
      session[:transaction_id] = logout_request.uuid
      # logger.info "New SP SLO for User ID: '#{session[:nameid]}', Transaction ID: '#{session[:transaction_id]}'"

      if settings.name_identifier_value.nil?
        settings.name_identifier_value = session[:nameid]
      end

      relay_state = url_for controller: 'saml', action: 'index'
      redirect_to(logout_request.create(settings, RelayState: relay_state))
    end
  end

  # After sending an SP initiated LogoutRequest to the IdP, we need to accept
  # the LogoutResponse, verify it, then actually delete our session.
  def process_logout_response
    settings = Account.get_saml_settings(url_base)
    request_id = session[:transaction_id]
    logout_response = OneLogin::RubySaml::Logoutresponse.new(
        params[:SAMLResponse],
        settings,
        matches_request_id: request_id,
        get_params: params
    )
    # logger.info "LogoutResponse is: #{logout_response.response}"

    validate_logout_response(logout_response)
  end

  def validate_logout_response(logout_response)
    # Validate the SAML Logout Response
    if !logout_response.validate
      error_msg = "The SAML Logout Response is invalid.  Errors: #{logout_response.errors}"
      logger.error error_msg
      render inline: error_msg
    elsif logout_response.success?
      # Actually log out this session
      # logger.info "Delete session for '#{session[:nameid]}'"
      reset_session
    end
    # render :action =>:index
  end

  # Method to handle IdP initiated logouts
  def idp_logout_request
    settings = Account.get_saml_settings(url_base)
    logout_request = OneLogin::RubySaml::SloLogoutrequest.new(params[:SAMLRequest], settings: settings)
    unless logout_request.is_valid?
      error_msg = "IdP initiated LogoutRequest was not valid!. Errors: #{logout_request.errors}"
      # logger.error error_msg
      render inline: error_msg
    end
    # logger.info "IdP initiated Logout for #{logout_request.nameid}"

    # Actually log out this session
    reset_session

    logout_response = OneLogin::RubySaml::SloLogoutresponse.new.create(
        settings,
        logout_request.id,
        nil,
        RelayState: params[:RelayState]
    )
    redirect_to logout_response
  end

  def url_base
    "#{request.protocol}#{request.host_with_port}"
  end
end
