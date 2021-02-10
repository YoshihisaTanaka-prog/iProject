class CommandsController < ApplicationController
    before_action :authenticate_admin!

    def top
    end

    def index
        object = NCMB::DataStore.new "TeacherParameter"
        @objects = object.all
    end

    def room
        object = NCMB::DataStore.new "TeacherParameter"
        @teacher = object.where("objectId",params['id']).first
    end

end
