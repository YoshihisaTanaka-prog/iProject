class AppUsersController < ApplicationController

    def domain
        if request.post? and check_token(params["token"])
            msg = params["id"] + "さんが" + params["domain"] + "というドメインを使用しました。\n確認お願いします。"
            url = "/autho/domain?cn=" + params["domain"]
            object1 = AdminChat.new()
            object1.autho_id = 0
            object1.group_id = 3
            object1.message = msg
            object1.url = url
            if object1.save
                render :plain => ""
            else
                render :plain => "Could not save!"
            end
        else
            render :plain => "Token is wrong!"
        end
    end

end
