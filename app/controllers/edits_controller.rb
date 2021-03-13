class EditsController < ApplicationController
    before_action :authenticate_admin!
    before_action -> { normal_limit(1)}
    layout 'autho', only: [:index]

    def index
        normal_limit 1
        if !params["class"].blank?
            object = NCMB::DataStore.new params["class"]
            @objects = object.all
            case params["class"]
            when "Region" then
                redirect_to autho_prefecture_path
            when "Domain" then
                redirect_to autho_domain_path
            when "TeacherParameter" then
                redirect_to autho_teacher_path
            when "Chat" then
                redirect_to autho_chat_path
            when "levelsetting" then
                redirect_to autho_levelsetting_path
            else
            end
        end
    end

    def caution
        normal_limit 1
        admin = current_admin
        p = "/autho/levelsetting?mail="
        if request.post?
            msg = admin.name + "さんが" + params['level'] + "以上のレベルを要求しています。"
            url = p + admin.email
            object = AdminChat.new(autho_id: 0, group_id: 2, message: msg, url: url)
            object.save
            if current_admin.admin_level == 0
                redirect_to caution_path(:level => params['level'])
            else
                redirect_to edit_caution_path(:level => params['level'])
            end
        else
            @is_able_to_send = true
            objects = AdminChat.where(url: p + admin.email).order(id: "DESC")
            if !objects.blank?
                time = objects.first.created_at.tomorrow
                if time > Time.current
                    @is_able_to_send = false
                    @rest_time = time - Time.current
                end
            end
        end
    end

    def create
        object = NCMB::DataStore.new params["class"]
        case params["class"]
        when "Chat"
            chat = object.new(chatGroupId: params["chatGroupId"], isGroup: params["isGroup"], message: params["message"])
            chat.acl = nil
            chat.save
            redirect_to root_path(:class => params["class"])
        when "Domain"
            if object.where("domain", params["domain"]).first.blank?
                domain = object.new(domain: params["domain"], collage: params["collage"], shortenCollege: params["shortenCollege"], prefecture: params["prefecture"])
                domain.acl = nil
                domain.save
                redirect_to root_path(:class => params["class"])
            else
                obj = object.where("domain", params["domain"]).first
                id = obj.objectId
                msg = "ドメインが存在するので、編集画面にリダイレクトしました。"
                redirect_to autho_path(:class => params["class"], :msg => msg, :id => id)
            end
        else
            redirect_to root_path(:class => params["class"])
        end
    end

    def edit
        object = NCMB::DataStore.new params["class"]
        @obj = object.where("objectId", params['id']).first
    end

    def update
        object = NCMB::DataStore.new params["class"]
        obj = object.where("objectId", params["objectId"]).first
        case params["class"]
        when "Domain"
            obj.domain = params["domain"]
            obj.collage = params["collage"]
            obj.shortenCollege = params["shortenCollege"]
            obj.prefecture = params["prefecture"]
            obj.acl = nil
            obj.save
            redirect_to root_path(:class => params["class"])
        else
        end
    end

end
