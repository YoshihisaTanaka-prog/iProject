class EditsController < ApplicationController
    before_action :authenticate_admin!

    def index
        normal_limit 1
        if !params["class"].blank?
            object = NCMB::DataStore.new params["class"]
            @objects = object.all
            case params["class"]
            when "Domain" then
                redirect_to autho_domain_path
            when "TeacherParameter" then
                redirect_to autho_teacher_path
            else
            end
        end
    end

    def caution
        normal_limit 1
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
