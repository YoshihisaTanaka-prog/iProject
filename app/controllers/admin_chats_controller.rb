class AdminChatsController < ApplicationController
    before_action :authenticate_admin!
    before_action -> { normal_limit(1)}
    layout 'chat', only: [:room]

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
            # グループの作成
            admin_special_num = AdminGroup.where(isSpecial: true).count-1
            admin_group_object = AdminGroup.new(name: params["name"])
            if params["isSpecial"] == "true"
                admin_group_object.isSpecial = true
                admin_group_object.special_id = admin_special_num
            end
            admin_group_object.save
            # グループにメンバーを追加
            group_admin_object = GroupAdmin.new(group_id: admin_group_object.id, admin_id: current_admin.id)
            group_admin_object.save
            if params["isSpecial"] == "true"
                admins = Admin.where(subadmin: true)
                admins.each do |a|
                    if a.id != current_admin.id
                        gao = GroupAdmin.new(group_id: admin_group_object.id, admin_id: a.id)
                        gao.save
                    end
                end
            end
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
            if params['id'].to_i == 2
                strong_limit
            end
            @room = AdminGroup.find(params['id'].to_i)
            if @room.isSpecial
                if @room.special_id > 0
                    group_limit @room.special_id
                end
            end
            @chats = AdminChat.where(group_id: params['id']).order(:id)
            @room_name = @room.name
            @path = autho_chat_admin_path
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
        if request.post?
            admin = GroupAdmin.where(group_id: params['room_id'].to_i, admin_id: params['admin_id'].to_i).first
            admin.delete
            redirect_to autho_chat_admin_room_members_path(:id => params["room_id"] )
        else
            admins = GroupAdmin.where(group_id: params['id'].to_i)
            @admins = []
            admins.each do |a|
                if a.admin_id != 0
                    admin = Admin.find(a.admin_id)
                    @admins.push(admin)
                end
            end
        end
    end

    def add_member
        if request.post?
            object = GroupAdmin.new()
            object.group_id = params['room_id'].to_i
            object.admin_id = params['admin_id'].to_i
            object.save
            redirect_to autho_chat_admin_room_path(id: params['room_id'])
        else
            admins = Admin.all
            ads = GroupAdmin.where(group_id: params['id'].to_s)
            current_member = []
            ads.each do |a|
                admin = Admin.find(a.admin_id)
                current_member.push(admin)
            end
            @admins = []
            admins.each do |a|
                if !current_member.include?(a) and a.id != 0 and a.level != "レベル0"
                    @admins.push(a)
                end
            end
        end
    end

end
