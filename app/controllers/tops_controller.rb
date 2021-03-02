class TopsController < ApplicationController
    before_action :authenticate_admin!, only: :caution

    def index
        if admin_signed_in?
            redirect_to  destroy_admin_session_path
        end
    end

    def caution
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
