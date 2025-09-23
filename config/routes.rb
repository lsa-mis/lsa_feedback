LsaTdxFeedback::Engine.routes.draw do
  post '/feedback', to: 'feedback#create', as: 'create_feedback'
end
