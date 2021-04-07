Rails.application.routes.draw do
  resources :prefectures
  resources :regions
  devise_for :admins
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root 'tops#index'

  # 制限された時に表示するページのURL
  get 'caution', to: 'tops#caution'
  post 'caution', to: 'tops#caution'
  get 'autho/caution', to: 'edits#caution'

  # 管理者用のトップページとアクセス権の注意のURL
  get 'autho', to: 'edits#index'
  get 'autho/caution', to: 'edits#caution'

  # 大学名などのデータをするためのURL
  get 'autho/domain', to: 'domains#index'
  post 'autho/domain/change', to: 'domains#change'
  post 'autho/domain/create', to: 'domains#create'
  get 'autho/domain/edit', to: 'domains#edit'
  post 'autho/domain/update', to: 'domains#update'
  get 'autho/domain/select', to: 'domains#select'
  post 'autho/domain/addpre', to: 'domains#add_prefecture'
  get 'autho/domain/shorten', to: 'domains#add_shorten'
  post 'autho/domain/shorten', to: 'domains#add_shorten'

  # 都道府県のデータを管理するためのURL
  get 'autho/prefecture', to: 'regions#index'

  # 教師の管理用（垢BANなど）用のURL
  get 'autho/teacher', to: 'teachers#index'
  post 'autho/teacher/update', to: 'teachers#update'


  # アプリのユーザーとのやり取りや運営同士でのやり取りをするチャットのためのURL
  get 'autho/chat', to: 'commands#top'

    # 教師への指示を出すためのチャットのURL
  get 'autho/chat/command', to: 'commands#index'
  get 'autho/chat/command/room', to: 'commands#room'

  # 　運営同士でのやり取りをするためのチャットのURL
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

  # チャット終了

  # 管理者の役割や権限を管理するためのページなどのURL
  get 'autho/levelsetting', to: 'level_settings#index'
  post 'autho/levelsetting', to: 'level_settings#edit'
  get 'autho/levelsetting/group', to: 'level_settings#group'
  post 'autho/levelsetting/group', to: 'level_settings#group'
  
  # ページ側のアクセス権を制限するためのページ
  get 'autho/limitation', to: 'ca_lists#index'
  get 'autho/limitation/new', to: 'ca_lists#new'
  post 'ca_lists', to: 'ca_lists#create'
  get 'autho/limitation/show', to: 'ca_lists#show'
  get 'autho/limitation/edit', to: 'ca_lists#edit'
  patch 'ca_list', to: 'ca_lists#update'
  delete 'ca_lists', to: 'ca_lists#destroy'
  get 'autho/limitation/showgroup', to: 'ca_limits#index'
  get 'autho/limitation/addgroup', to: 'ca_limits#new'
  post 'autho/limitation/addgroup', to: 'ca_limits#create'
  delete 'autho/limitation/deletegroup', to: 'ca_limits#delete'


  # アプリとの通信用
  post 'app/user/domain', to: 'app_users#domain'

end
