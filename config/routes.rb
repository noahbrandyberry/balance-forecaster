Rails.application.routes.draw do
  devise_for :users

  resources :accounts do
    resources :items
    get '/forecast', to: 'items#forecast', as: 'forecast'
    get '/items/:id/edit_occurrence/:date', to: 'items#edit_occurrence', as: 'edit_occurrence'
    post '/items/:id/update_occurrence/:date', to: 'items#update_occurrence', as: 'update_occurrence'
    post '/items/:id/revert_occurrence/:date', to: 'items#revert_occurrence', as: 'revert_occurrence'
    delete '/items/:id/delete_occurrence/:date', to: 'items#delete_occurrence', as: 'delete_occurrence'
  end

  root 'home#index'
end
