class TeachersController < ApplicationController
    before_action :authenticate_admin!
    before_action :make_option , only: [:index]

    def index
        object = NCMB::DataStore.new "TeacherParameter"
        if params['id'].blank?
            @objects = object.all
        else
            @objects = object.where("objectId",params['id'])
        end
    end

    def update
        object = NCMB::DataStore.new "TeacherParameter"
        if !params["objectId"].blank?
            obj = object.where("objectId",params['objectId']).first
            obj.isAbleToTeach = !obj.isAbleToTeach
            obj.acl = nil
            obj.save
        end
        redirect_to autho_teacher_path
    end

end
