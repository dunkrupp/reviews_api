# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Reviews::Collect do
  describe '#call' do
    let(:invalid_url) { URI('invalid_url') }
    let(:target_url) { URI(url) }
    let(:url) { 'https://www.example.com/reviews' }

    context 'when the URL is valid and reviews are found' do
      it 'returns a Success monad with reviews' do
        mock_faraday_response = double(Faraday::Response, success?: true, body: '<html><body><div data-aqa-id="feedback-container"><div data-aqa-id="customer-name">John Doe</div><div data-aqa-id="star-rating-filled"><div data-aqa-id="star"></div><div data-aqa-id="star"></div><div data-aqa-id="star"></div></div></div></body></html>')
        mock_faraday_connection = double(Faraday::Response)
        allow(Faraday).to receive(:new).and_return(mock_faraday_connection)
        allow(mock_faraday_connection).to receive(:get).with(target_url).and_return(mock_faraday_response)

        result = described_class.new.call(url)
        expect(result).to be_a(Dry::Monads::Success)
        expect(result.value!).to be_a(Hash)
        expect(result.value![:reviews]).to be_an(Array)
        expect(result.value![:reviews].first).to be_a(Review)
        expect(result.value![:reviews].first.author).to eq('John Doe')
        expect(result.value![:reviews].first.rating).to eq(3)
      end
    end

    context 'when the URL is invalid or the page is not found' do
      it 'returns a Failure monad with an error message' do
        mock_faraday_response = double(Faraday::Response, success?: false)
        mock_faraday_connection = double(Faraday::Connection)
        allow(Faraday).to receive(:new).and_return(mock_faraday_connection)
        allow(mock_faraday_connection).to receive(:get).with(invalid_url).and_return(mock_faraday_response)

        result = described_class.new.call('invalid_url')
        expect(result).to be_a(Dry::Monads::Failure)
        expect(result.failure).to eq('An unexpected error occurred: Invalid URL, or page not found')
      end
    end

    context 'when a Faraday error occurs' do
      it 'returns a Failure monad with an error message' do
        mock_faraday_connection = double(Faraday::Response)
        allow(Faraday).to receive(:new).and_return(mock_faraday_connection)
        allow(mock_faraday_connection).to receive(:get).with(target_url).and_raise(Faraday::ConnectionFailed, 'Network error')

        result = described_class.new.call(url)
        expect(result).to be_a(Dry::Monads::Failure)
        expect(result.failure).to eq('Error fetching reviews: Network error')
      end
    end

    context 'when an unexpected error occurs' do
      it 'returns a Failure monad with an error message' do
        mock_faraday_response = double(Faraday::Response, success?: true, body: '<html></html>')
        mock_faraday_connection = double(Faraday::Response)
        allow(Faraday).to receive(:new).and_return(mock_faraday_connection)
        allow(mock_faraday_connection).to receive(:get).with(target_url).and_return(mock_faraday_response)
        allow_any_instance_of(Nokogiri::HTML::Document).to receive(:css).and_raise('Unexpected error')

        result = described_class.new.call(url)
        expect(result).to be_a(Dry::Monads::Failure)
        expect(result.failure).to eq('An unexpected error occurred: Unexpected error')
      end
    end

    context 'when parsing reviews' do
      let(:html) { '<html><body><div data-aqa-id="feedback-container"><div data-aqa-id="customer-name">John Doe</div><div data-aqa-id="star-rating-filled"><div data-aqa-id="star"></div><div data-aqa-id="star"></div><div data-aqa-id="star"></div></div></div></body></html>' }
      let(:doc) { Nokogiri::HTML(html) }
      let(:container) { doc.at_css('[data-aqa-id="feedback-container"]') }

      it 'correctly parses a review from HTML' do
        review = described_class.new.send(:parse_review, container)
        expect(review).to be_a(Review)
        expect(review.author).to eq('John Doe')
        expect(review.rating).to eq(3)
      end

      it 'correctly parses multiple reviews' do
        html_multiple = '<html><body><div data-aqa-id="feedback-container"><div data-aqa-id="customer-name">John Doe</div><div data-aqa-id="star-rating-filled"><div data-aqa-id="star"></div><div data-aqa-id="star"></div><div data-aqa-id="star"></div></div></div><div data-aqa-id="feedback-container"><div data-aqa-id="customer-name">Jane Doe</div><div data-aqa-id="star-rating-filled"><div data-aqa-id="star"></div><div data-aqa-id="star"></div></div></div></body></html>'
        reviews = described_class.new.send(:parse_reviews, html_multiple)
        expect(reviews.length).to eq(2)
        expect(reviews.first).to be_a(Review)
        expect(reviews.last.author).to eq("Jane Doe")
        expect(reviews.last.rating).to eq(2)
      end
    end
  end
end
