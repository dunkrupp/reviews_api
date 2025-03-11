# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::ReviewsController, type: :request do
  describe 'POST /api/v1/reviews/collect' do
    let(:failure) { Dry::Monads::Failure('Operation failed') }
    let(:json) { JSON.parse(response.body) }
    let(:success) { Dry::Monads::Success({ reviews: [ { author: 'Bob Loblaw',  content: 'Test review', likes: 3, rating: 3 } ] }) }
    let(:valid_url) { 'https://www.example.com/reviews' }

    context 'when the request is valid and reviews are collected' do
      it 'returns a successful response with reviews' do
        mock_operation = instance_double(Reviews::Collect)
        allow(mock_operation).to receive(:call).and_return(success)
        allow(Reviews::Collect).to receive(:new).and_return(mock_operation)

        get '/api/v1/reviews/collect', params: { target_url: valid_url }

        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(json).to eq({ 'reviews' => [ { "author"=>"Bob Loblaw", "content"=>"Test review", "likes"=>3, "rating"=>3 } ] })
      end
    end

    context 'when the request is invalid (missing target_url)' do
      it 'returns a bad request response with an error' do
        get '/api/v1/reviews/collect', params: {}

        expect(response).to have_http_status(:bad_request)
        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(json).to have_key('errors')
        expect(json['errors']).to be_a(String)
      end
    end

    context 'when the Reviews::Collect operation fails' do
      it 'returns a bad request response with an error message' do
        mock_operation = instance_double(Reviews::Collect)
        allow(mock_operation).to receive(:call).and_return(Dry::Monads::Failure('Operation failed'))
        allow(Reviews::Collect).to receive(:new).and_return(mock_operation)

        get '/api/v1/reviews/collect', params: { target_url: valid_url }

        expect(response).to have_http_status(:bad_request)
        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(json).to eq({ 'errors' => 'Operation failed' })
      end
    end
  end
end
