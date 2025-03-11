Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  root "rails/health#show"

  namespace :api do
    namespace :v1 do
      get "reviews/collect", to: "reviews#collect", as: :collect_reviews
    end
  end
end
