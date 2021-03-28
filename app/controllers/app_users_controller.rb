class AppUsersController < ApplicationController

    def domain
        if request.post? and check_token(params[:token])
            msg = params[:id] + "さんが" + params["domain"] + "というドメインを使用しました。\n確認お願いします。"
            url = "/autho/domain?cn=" + params["domain"]
            object1 = AdminChat.new(autho_id: 0, group_id: 2, message: msg, url: url)
            object1.save
        end
    end

end
