Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Mount the feedback gem engine
  mount LsaTdxFeedback::Engine => '/lsa_tdx_feedback'

  # Defines the root path route ("/")
  root "application#index"
end
