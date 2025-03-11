# frozen_string_literal: true

require "nokogiri"

module Reviews
  class Collect < ::BaseOperation
    def call(url)
      Success(fetch_and_parse_reviews(url))
    rescue ::Faraday::Error => e
      Failure("Error fetching reviews: #{e.message}")
    rescue ::StandardError => e
      Failure("An unexpected error occurred: #{e.message}")
    end

    private

    def fetch_and_parse_reviews(url)
      uri = URI(url)
      connection = ::Faraday.new
      response = connection.get(uri)

      raise "Invalid URL, or page not found" unless response.success?

      reviews = parse_reviews(response.body)

      # @note: normally could use serializers in the controller
      {
        url:,
        count: reviews.count,
        reviews:
      }
    end

    # @todo: cleanup
    def parse_review(doc)
      rating = 0
      customer_name_element = doc.at_css('[data-aqa-id="customer-name"]')
      customer_comment_element = doc.at_css('[data-aqa-id="customer-comment"]')
      customer_feedback_date_element = doc.at_css('[data-aqa-id="customer-feedback-date"]')
      customer_location_element = doc.at_css('[data-aqa-id="customer-location"]')
      customer_purchased_date_element = doc.at_css('[data-aqa-id="customer-purchased-date"]')
      customer_comment_likes_element = doc.at_css('[data-aqa-id="feedback-like-button"]')
      star_rating_container = doc.at_css('[data-aqa-id="star-rating"]')

      if star_rating_container
        stars = star_rating_container.css('[data-aqa-id="star"]')
        rating = stars.count
      end

      Review.new(
        author: customer_name_element&.text&.strip,
        content: customer_purchased_date_element&.text&.strip,
        likes: customer_comment_likes_element&.text&.strip,
        location: customer_location_element&.text&.strip,
        purchase_date: customer_comment_element&.text&.strip,
        rating:,
        review_date: customer_feedback_date_element&.text&.strip,
        )
    end

    def parse_reviews(html)
      doc = ::Nokogiri::HTML(html)

      # @note: `.feedback-containers` refer to the html container for each 'review'
      # @todo: need to add page traversal for more reviews, only gets the first page.
      feedback_containers = doc.css('[data-aqa-id="feedback-container"]')
      feedback_containers.map { |review| parse_review(review) }
    end
  end
end
