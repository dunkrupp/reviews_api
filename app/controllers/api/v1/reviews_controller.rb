# frozen_string_literal: true

module Api
  module V1
    class ReviewsController < ::Api::BaseController
      schemas[:collect] = Dry::Schema.Params do
        required(:target_url).filled(:string)
      end

      def collect
        result = Reviews::Collect.new.call(safe_params[:target_url])

        return bad_request(result.failure) if result.failure?

        render json: result.value!
      end
    end
  end
end
