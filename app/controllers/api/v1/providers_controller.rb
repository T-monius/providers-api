module Api::V1
  class ProvidersController < ApplicationController
    def index
      @providers = Provider.all
      render json: @providers
    end

    def create
      @provider = Provider.create(provider_params)
      render json: @provider
    end

    private

      def provider_params
        params.require(:provider)
          .permit(:address, :name, :npi, :organization, :telephone_number)
      end
  end
end