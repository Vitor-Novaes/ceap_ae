Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  namespace :v1 do
    post 'import-data', to: 'expenditures#import_data'

    resources :organizations, only: %i[show index]
    resources :deputies, only: %i[show index]
    resources :expenditures, only: %i[index show]
  end
end
