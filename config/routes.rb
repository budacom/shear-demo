Rails.application.routes.draw do
  get "", to: 'demo#index'
  get "process_image", to: 'demo#process_image'
  mount Sidekiq::Web => '/queue'
end
