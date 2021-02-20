Rails.application.routes.draw do
  resources :prefectures
  resources :regions
  devise_for :admins
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root 'tops#index'

  get 'caution', to: 'tops#caution'
  get 'autho/caution', to: 'edits#caution'

  get 'autho', to: 'edits#index'
  post 'autho/create' , to: 'edits#create'
  get 'autho/edit' , to: 'edits#edit'
  post 'autho/update' , to: 'edits#update'

  get 'autho/domain', to: 'domains#index'
  post 'autho/domain/change', to: 'domains#change'
  post 'autho/domain/create', to: 'domains#create'
  get 'autho/domain/edit', to: 'domains#edit'
  post 'autho/domain/update', to: 'domains#update'
  get 'autho/domain/select', to: 'domains#select'
  post 'autho/domain/addpre', to: 'domains#add_prefecture'

  get 'autho/prefecture', to: 'regions#index'

  get 'autho/teacher', to: 'teachers#index'
  post 'autho/teacher/update', to: 'teachers#update'

  get 'autho/chat', to: 'commands#top'
  get 'autho/chat/command', to: 'commands#index'
  get 'autho/chat/command/room', to: 'commands#room'

end
