Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Mount the feedback gem engine
  mount FeedbackGem::Engine => '/feedback_gem'

  # Defines the root path route ("/")
  root "application#index"
end
