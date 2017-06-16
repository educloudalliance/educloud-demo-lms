class PagesController < ApplicationController
  # require 'rest-client'
  def index; end

  def browse
    # @response = RestClient.get 'http://educloud.dev/api/v1/cms/materials', {accept: :json}
    # puts @response.to_yaml
    # base_url = 'http://google.com'

    base_url = 'http://educloud.dev/api/v1/lms/browse'

    # event = {'summary': 'Test RestClient event', 'start': {'dateTime': Time.now.strftime('%FT%T%z')}, 'end': {'dateTime': (Time.now + 3600).strftime('%FT%T%z')}}
    #
    # result = RestClient::Request.execute(method: :get, url: base_url)
    # JSON.parse(result)
    # begin
    #   RestClient.get(base_url)
    # rescue RestClient::Exception => err
    #   puts err.response.body
    # end

    # begin
    #   RestClient.get base_url
    # rescue RestClient::ExceptionWithResponse => e
    #   @response = e.response
    # end

    @response = HTTParty.post(base_url)
  end
end
