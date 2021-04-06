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
            when "limitation"
                redirect_to autho_limitation_path
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

end
