Rails.application.routes.draw do
  get "", to: 'demo#index'
  mount Sidekiq::Web => '/queue'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
