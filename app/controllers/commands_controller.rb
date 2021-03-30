class CommandsController < ApplicationController
    before_action :authenticate_admin!
    before_action :make_option
    before_action -> { normal_limit(1)}
    layout 'autho', only: [:top]

    def top
    end

    def index
        object = NCMB::DataStore.new "TeacherParameter"
        @objects = object.all
    end

    def room
        object = NCMB::DataStore.new "TeacherParameter"
        @teacher = object.where("userId", params['id']).first
    end

end
