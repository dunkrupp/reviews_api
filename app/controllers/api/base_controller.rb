# frozen_string_literal: true

module Api
  # Base controller for API endpoints.
  # Provides common methods and configurations for API controllers.
  class BaseController < ::ApplicationController
    include ::Dry::Monads::Result::Mixin

    private

    # Renders a bad request response with the given message.
    #
    # @param errors [Hash] The error message to include in the response.
    # @return [void]
    def bad_request(errors = { status: "Bad Request" })
      render json: { errors: }, status: :bad_request
    end
  end
end
