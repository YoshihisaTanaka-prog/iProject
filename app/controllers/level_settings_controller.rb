class LevelSettingsController < ApplicationController
    before_action :authenticate_admin!
    before_action :strong_limit

    def index
        if params['mail'].blank?
            @admins = Admin.all
        else
            @admins = Admin.where(email: params['mail'])
        end
    end

    def edit
        case params['mode']
        when "admin"
            my_object = Admin.find(current_admin.id)
            my_object.admin = false
            my_object.save
            object = Admin.find(params['id'].to_i)
            object.admin = true
            object.save
        when "subadmin"
            object = Admin.find(params['id'].to_i)
            object.subadmin = !object.subadmin
            object.save
            if object.subadmin
                if GroupAdmin.where(group_id: 2, admin_id: params['id'].to_i).length == 0
                    group_admin_object = GroupAdmin.new(group_id: 2, admin_id: params['id'].to_i)
                    group_admin_object.save
                end
                if GroupAdmin.where(group_id: 1, admin_id: params['id'].to_i).length == 0
                    group_admin_object = GroupAdmin.new(group_id: 1, admin_id: params['id'].to_i)
                    group_admin_object.save
                end
            else
                group_admin_object = GroupAdmin.where(group_id: 2, admin_id: params['id'].to_i).first
                group_admin_object.destroy
            end
        else
            object = Admin.find(params['id'].to_i)
            object.admin_level = params['level'].to_i
            object.save
            if object.admin_level == 1 and GroupAdmin.where(group_id: 1, admin_id: params['id'].to_i).length == 0
                group_admin_object = GroupAdmin.new(group_id: 1, admin_id: params['id'].to_i)
                group_admin_object.save
            end
        end
        if params['mail'].blank?
            redirect_to autho_levelsetting_path
        else
            redirect_to autho_levelsetting_path(:mail => params['mail'])
        end
    end

end
