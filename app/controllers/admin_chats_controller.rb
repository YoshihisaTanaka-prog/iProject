class AdminChatsController < ApplicationController
    before_action :authenticate_admin!
    before_action -> { normal_limit(1)}

    def index
        group_ids = GroupAdmin.where(admin_id: current_admin.id)
        @groups = []

        group_ids.each do |g|
            group = AdminGroup.find(g.group_id)
            @groups.push(group)
        end
    end

    def new
        normal_limit 2
        if request.post?
            admin_group_object = AdminGroup.new(name: params["name"])
            admin_group_object.save
            group_admin_object = GroupAdmin.new(group_id: admin_group_object.id, admin_id: current_admin.id)
            group_admin_object.save
            redirect_to autho_chat_admin_path
        end
    end

    # 部屋の中
    def room
        if request.post?
            render plain: "post"
        elsif request.delete?
            if GroupAdmin.where(group_id: params['id']).length == 1
                group_object = AdminGroup.find(params['id'].to_i)
            end
            object = GroupAdmin.where(group_id: params['id'], admin_id: current_admin.id).first
            object.destroy
            redirect_to autho_chat_admin_path
        else
            if params['id'] == 2
                strong_limit
            end
            @chats = AdminChat.where(group_id: params['id']).order(:id)
        end
    end

    def talk
        if request.post?
            object = AdminChat.new(group_id: params['group_id'], message: params['message'], autho_id: params['admin_id'])
            object.save
        end
        redirect_to autho_chat_admin_room_path(:id => params['group_id'])
    end

    def members
        admins = GroupAdmin.where(group_id: params['id'].to_s)
        @admins = []
        admins.each do |a|
            admin = Admin.find(a.admin_id)
            @admins.push(admin)
        end
    end

end
