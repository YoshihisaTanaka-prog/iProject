class SupportChatController < ApplicationController
    before_action :authenticate_admin!
    before_action -> { normal_limit(1)}
    layout 'autho', only: [:top]
    layout 'chat', only: [:room]

    def index
        @users = User.where(role: 'student').order(last_sent_time: "DESC")
        @ncmb_users = []
        objects = []
        @users.each do |u|
            objects.push(NCMB::DataStore.new "StudentParameter")
            nu = objects.last.where("userId", u.user_id).first
            if nu.blank?
                u.destroy
            else
                @ncmb_users.push(objects.last.where("userId", u.user_id).first)
            end
        end
    end

    def room
        object = NCMB::DataStore.new "StudentParameter"
        @student = object.where("objectId", params['id']).first
        chat_object = NCMB::DataStore.new "Chat"
        @chats = chat_object.where("chatRoomId", "user-" + @student.userId)

        @room_name = @student.userName + "さん (" + @student.schoolName + ") へのチャット"
        @path = autho_chat_support_path

        @chats.each do |c|
            if c.sentUserId != "sapo-to" && !c.readUserIds.include?("sapo-to")
                c.readUserIds.push("sapo-to")
                c.acl = nil
                c.save
            end
        end

        s = User.find_by(role: 'student', parameter_id: params['id'])
        if !s.blank?
            s.unread_count = 0
            s.save
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

        s = User.find_by(role: 'student', parameter_id: params['id'])
        if !s.blank?
            s.last_sent_time = DateTime.now
            s.save
        end
        
        if chat.save
            redirect_to autho_chat_support_room_path(:id => params[:id])
        end

    end

end
