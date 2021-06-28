class ApplicationController < ActionController::Base
    before_action :set_color
    before_action :make_option
    before_action :limit
    
    require 'rack'
    require 'ncmb'
    NCMB.initialize(
        application_key: ENV['NCMB_APP_KEY'],
        client_key: ENV['NCMB_CLIENT_KEY']
    )

    def strongest_limit
        if admin_signed_in?
            if current_admin.admin
                return
            elsif current_admin.admin_level == 0
                redirect_to caution_path(:level => "最高権限")
            else
                redirect_to edit_caution_path(:level => "最高権限")
            end
        end
    end

    def strong_limit
        if admin_signed_in?
            if current_admin.subadmin
                return
            elsif current_admin.admin_level == 0
                redirect_to caution_path(:level => "幹部権限")
            else
                redirect_to autho_caution_path(:level => "幹部権限")
            end
        end
    end

    def limit
        if admin_signed_in?
            c_name = controller_name
            a_name = action_name
            cals = CaList.where(controller_name: c_name, action_name: a_name)
            if cals.blank?
                return
            else
                cal = cals.first
                minimum_level = cal.minimum_level
                if cal.is_only_admin
                    if current_admin.admin
                        return
                    else
                        if current_admin.admin_level == 0
                            redirect_to caution_path(:level => "最高権限のみ")
                        else
                            redirect_to autho_caution_path(:level => "最高権限のみ")
                        end
                    end
                elsif cal.is_only_subadmin
                    if current_admin.subadmin
                        return
                    else
                        if current_admin.admin_level == 0
                            redirect_to caution_path(:level => "準最高権限のみ")
                        else
                            redirect_to autho_caution_path(:level => "準最高権限のみ")
                        end
                    end
                elsif cal.is_only_level
                    normal_limit(minimum_level)
                else
                    if current_admin.subadmin
                        return
                    else
                        # グループ分け
                        cal_limits = cal.ca_limits.order(:admin_group_id).pluck(:admin_group_id)
                        ags = GroupAdmin.where(admin_id: current_admin.id).order(:group_id).pluck(:group_id)
                        ags.each do |a|
                            if cal_limits.include?(a)
                                normal_limit(minimum_level)
                            end
                        end
                        if current_admin.admin_level == 0
                            redirect_to caution_path(:level => "グループ: " + group_list(cal_limits) + "のみの権限")
                        else
                            redirect_to autho_caution_path(:level => "グループ: " + group_list(cal_limits) + "のみの権限")
                        end
                    end
                end
            end
        end
    end

    def group_list list
        ret = ""
        list.each do |l|
            ret += l.to_s + ", "
        end
        return ret
    end

    def normal_limit min
        if admin_signed_in?
            if current_admin.subadmin
                return
            elsif current_admin.admin_level < min
                if current_admin.admin_level == 0
                    redirect_to caution_path(:level => "レベル" + min.to_s + "以上の権限")
                else
                    redirect_to autho_caution_path(:level => "レベル" + min.to_s + "以上の権限")
                end
            else
                return
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
        if admin_signed_in?
            @options = [["アクセス権の管理","/autho/limitation","ca_lists"]]
            @options.push(["権限の管理","/autho/levelsetting","level_settings"])
            @options.push(["チャット","/autho/chat","commands"])
            @options.push(["ドメインの編集","/autho/domain","domains"])
            @options.push(["都道府県の編集","/autho/prefecture","regions"])
            @options.push(["生徒の管理","StudentParameter",""])
            @options.push(["教師の管理","/autho/teacher","teachers"])
        end
    end

    def set_color
        @concept_color = "backGround: #3778ff; color: #000032;"
        @base_color    = "backGround: #c4dcff; color: #000032;"
        @accent_color  = "backGround: #ffff32; color: #000032;"
    end

    # devise用のカラムを追加するために必要
    before_action :configure_permitted_parameters, if: :devise_controller?
    def configure_permitted_parameters
        devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
        devise_parameter_sanitizer.permit(:account_update, keys: [:name])
    end

    def check_token(token)
        if token == ENV["APP_KEY"]
            return true
        else
            return false
        end
    end
    
end
