class ApplicationController < ActionController::Base
    before_action :set_color

    require 'rack'
    require 'ncmb'
    NCMB.initialize(
        application_key: "ff2eb018c242f1f1583c5de5b0839224c4b070f08cb4c6ad5f43bb90a86d690e",
        client_key: "1c892f55e7e3b5533a8e6a1b5601a747e01707a81fcb162f9d68133d55f347e7"
    )

    def strongest_limit
        if current_admin.admin
            return
        elsif current_admin.admin_level == 0
            redirect_to caution_path(:level => "最高権限")
        else
            redirect_to edit_caution_path(:level => "最高権限")
        end
    end

    def strong_limit
        if current_admin.subadmin
            return
        elsif current_admin.admin_level == 0
            redirect_to caution_path(:level => "幹部権限")
        else
            redirect_to edit_caution_path(:level => "幹部権限")
        end
    end

    def normal_limit min
        if current_admin.subadmin
            return
        elsif current_admin.admin_level < min
            if current_admin.admin_level == 0
                redirect_to caution_path(:level => "レベル" + min.to_s + "以上の権限")
            else
                redirect_to edit_caution_path(:level => "レベル" + min.to_s + "以上の権限")
            end
        else
            return
        end
    end

    def group_limit group
        if !current_admin.subadmin
            objects = GroupAdmin.where(admin_id: current_admin.id)
            objects.each do |o|
                if o.group_id == group
                    return
                end
            end
            if current_admin.admin_level == 0
                redirect_to caution_path(:level => "グループ" + min.to_s + "の権限")
            else
                redirect_to edit_caution_path(:level => "グループ" + min.to_s + "の権限")
            end
        end
    end

    def after_sign_in_path_for(resource)
        autho_path
    end
    
    def after_sign_out_path_for(resource)
        root_path
    end

    def make_option
        @option = {Top: nil, Chat: "Chat", ChatGroup: "ChatGroup", ChatRead: "ChatRead", Domain: "Domain", OneOnOneChat: "OneOnOneChat",Prefecture: "Region",Review: "Review", StudentParameter: "StudentParameter", TeacherParameter: "TeacherParameter", UserChatGroup: "UserChatGroup"}
    end

    def set_color
        @concept_color = "backGround: #3778ff; color: #000032;"
        @base_color    = "backGround: #c4dcff; color: #000032;"
        @accent_color  = "backGround: #ffff32; color: #000032;"
    end
    
end
