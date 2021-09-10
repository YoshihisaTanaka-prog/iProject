class CommandsController < ApplicationController
    before_action :authenticate_admin!
    before_action :make_option
    before_action -> { normal_limit(1)}
    layout 'autho', only: [:top]
    layout 'chat', only: [:room]

    def top
    end

    def index
        @users = User.where(role: 'teacher').order(last_sent_time: "DESC")
        @ncmb_users = []
        objects = []
        @users.each do |u|
            objects.push(NCMB::DataStore.new "TeacherParameter")
            @ncmb_users.push(objects.last.where("userId", u.user_id).first)
        end
    end

    def room
        object = NCMB::DataStore.new "TeacherParameter"
        @teacher = object.where("objectId", params['id']).first
        chat_object = NCMB::DataStore.new "Chat"
        @chats = chat_object.where("chatRoomId", "user-" + @teacher.userId)

        @room_name = @teacher.userName + "先生 (" + @teacher.collage + ") へのチャット"
        @path = autho_chat_command_path

        @chats.each do |c|
            if c.sentUserId != "sapo-to" && !c.readUserIds.include?("sapo-to")
                c.readUserIds.push("sapo-to")
                c.acl = nil
                c.save
            end
        end
        t = User.find_by(role: 'teacher', parameter_id: params['id'])
        if !t.blank?
            t.unread_count = 0
            t.save
        end
    end

    def send_message
        object = NCMB::DataStore.new "Chat"
        chat = object.new()
        chat.acl = nil
        chat.sentUserId = "sapo-to"
        chat.readUserIds = []
        chat.message = params[:message]
        chat.chatRoomId = params[:chatRoomId]

        if chat.save
            redirect_to autho_chat_command_room_path(:id => params[:id])
        end

    end

end
