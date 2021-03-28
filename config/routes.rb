Rails.application.routes.draw do
  resources :prefectures
  resources :regions
  devise_for :admins
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root 'tops#index'

  get 'caution', to: 'tops#caution'
  post 'caution', to: 'tops#caution'
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
  get 'autho/domain/shorten', to: 'domains#add_shorten'
  post 'autho/domain/shorten', to: 'domains#add_shorten'

  get 'autho/prefecture', to: 'regions#index'

  get 'autho/teacher', to: 'teachers#index'
  post 'autho/teacher/update', to: 'teachers#update'

  get 'autho/chat', to: 'commands#top'
  get 'autho/chat/command', to: 'commands#index'
  get 'autho/chat/command/room', to: 'commands#room'
  get 'autho/chat/admin', to: 'admin_chats#index'
  get 'autho/chat/admin/new', to: 'admin_chats#new'
  post 'autho/chat/admin/new', to: 'admin_chats#new'
  post 'autho/chat/admin/talk', to: 'admin_chats#talk'
  get 'autho/chat/admin/room/members', to: 'admin_chats#members'
  post 'autho/chat/admin/room/members', to: 'admin_chats#members'
  get 'autho/chat/admin/room/add', to: 'admin_chats#add_member'
  post 'autho/chat/admin/room/add', to: 'admin_chats#add_member'
  get 'autho/chat/admin/room', to: 'admin_chats#room'
  post 'autho/chat/admin/room', to: 'admin_chats#room'
  delete 'autho/chat/admin/room', to: 'admin_chats#room'

  get 'autho/levelsetting', to: 'level_settings#index'
  post 'autho/levelsetting', to: 'level_settings#edit'
  get 'autho/levelsetting/group', to: 'level_settings#group'
  post 'autho/levelsetting/group', to: 'level_settings#group'

  post 'app/user', to: 'app_users#domain'

end
