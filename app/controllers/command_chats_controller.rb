class CommandChatsController < ApplicationController
    before_action :authenticate_admin!
    before_action -> { normal_limit(1)}
end
