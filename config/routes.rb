require 'sidekiq/web'
require 'sidekiq/cron/web'

# Configure Sidekiq-specific session middleware
Sidekiq::Web.use ActionDispatch::Cookies
Sidekiq::Web.use Rails.application.config.session_store, Rails.application.config.session_options

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  mount Sidekiq::Web => '/sidekiq'

  namespace :v1 do
    resources :deputies, only: %i[show index]
    resources :expenditures, only: %i[index show]
    post 'expenditures/import/', to: 'expenditures#import_data'

    resources :organizations, only: %i[index]
    resources :categories, only: %i[index]
  end
end
