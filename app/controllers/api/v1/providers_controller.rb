require 'excon'

module Api::V1
  class ProvidersController < ApplicationController
    def index
      @providers = Provider.all
      render json: @providers
    end

    def create
      puts provider_params
      provider_response = request_provider(provider_params[:npi])
      if provider_response
        @provider = Provider.create(format_provider_response(provider_response))
        render json: @provider
      end
    end

    private

    def provider_params
      params.require(:provider).permit(:npi)
    end

    def get_from_external_api(url)
      response = Excon.get(url)
      return nil if response.status != 200
      JSON.parse(response.body)
    end

    def request_provider(npi)
      get_from_external_api("https://npiregistry.cms.hhs.gov/api/?version=2.0&number=#{npi}")
    end

    def format_provider_response(provider_response)
        result = provider_response.dig('results', 0)
        provider_info = result['basic']
        location = result['addresses'].find { |address| address['address_purpose'] == 'LOCATION'}
        {
          npi: result['number'],
          name: "#{provider_info['name_prefix']} #{provider_info['first_name']} #{provider_info['last_name']} #{provider_info['credential']}",
          telephone_number: location['telephone_number'],
          address: "#{location['address_1']}, #{location['city']}, #{location['state']}, #{location['postal_code']}, #{location['country_name']}",
          organization: result['enumeration_type'] == 'NPI-2'
        }
    end
  end
end