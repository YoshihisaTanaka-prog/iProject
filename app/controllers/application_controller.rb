class ApplicationController < ActionController::Base

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
            redirect_to caution_path
        else
            redirect_to edit_caution_path
        end
    end

    def strong_limit
        if current_admin.subadmin
        elsif current_admin.admin_level == 0
            redirect_to caution_path
        else
            redirect_to edit_caution_path
        end
    end

    def normal_limit min
        if current_admin.subadmin
            return
        elsif current_admin.admin_level < min
            if current_admin.admin_level == 0
                redirect_to caution_path
            else
                redirect_to edit_caution_path
            end
        else
            return
        end
    end

    def after_sign_in_path_for(resource)
        autho_path
    end
    
    def after_sign_out_path_for(resource)
        root_path
    end

    def make_option
        @option = {Chat: "Chat", ChatGroup: "ChatGroup", ChatRead: "ChatRead", Domain: "Domain", OneOnOneChat: "OneOnOneChat",Prefecture: "Region",Review: "Review", StudentParameter: "StudentParameter", TeacherParameter: "TeacherParameter", UserChatGroup: "UserChatGroup"}
    end
    
end
