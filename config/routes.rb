Rails.application.routes.draw do
  resources :tao_bao_items, only: [:index]
end
