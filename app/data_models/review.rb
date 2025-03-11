# frozen_string_literal: true

class Review
  attr_accessor :author, :content, :location, :likes, :purchase_date, :rating, :review_date

  def initialize(author: nil, content: nil, likes: 0, location: nil, purchase_date: nil, rating: 0, review_date: nil)
    @author = author
    @content = content
    @location = location
    @purchase_date = purchase_date
    @rating = rating
    @review_date = review_date
  end

  def ==(other)
    other.is_a?(Review) && to_h == other.to_h
  end
end
