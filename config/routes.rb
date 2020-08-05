Rails.application.routes.draw do
  get "", to: 'demo#index'
  post "process_image", to: 'demo#process_image'
  post "upload", to: 'demo#upload'
  mount Sidekiq::Web => '/queue'
end
