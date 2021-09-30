class ReportsController < ApplicationController
    before_action -> {
        authenticate_admin! 
        strongest_limit
    }

    def index
        @reports = Report.all()
        @users = User.all()
    end
end
