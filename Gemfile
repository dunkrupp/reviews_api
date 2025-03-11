# frozen_string_literal: true

source "https://rubygems.org"

gem "dry-monads"
gem "dry-rails"
gem "faraday"
gem "nokogiri"
gem "puma", ">= 5.0"
gem "rack-cors"
gem "rails", "~> 8.0.1"
gem "solid_cache"
gem "solid_queue"
gem "sqlite3", ">= 2.1"
gem "thruster", require: false
gem "tzinfo-data", platforms: [ :windows, :jruby ]

group :development do
  gem "brakeman", require: false
  gem "debug", platforms: [ :mri, :windows ], require: "debug/prelude"
  gem "rubocop-rails-omakase", require: false
  gem "rubocop-performance", require: false
end

group :test do
  gem "rspec-rails"
end
