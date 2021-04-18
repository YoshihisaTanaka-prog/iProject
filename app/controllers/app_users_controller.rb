class AppUsersController < ApplicationController

    skip_before_action :verify_authenticity_token

    def domain
        if request.post? and check_token(params["token"])
            if params["banned"].blank?
                msg1 = params["id"] + "さんが未確認のドメインを使用しました。"
                msg2 = params["domain"] + "というドメインです。"
                url1 = "/autho/chat/command/room?id=" + params["id"]
                url2 = "/autho/domain?cn=" + params["domain"]
                # 一つ目のメッセージを作成
                object1 = AdminChat.new()
                object1.autho_id = 0
                object1.group_id = 3
                object1.message = msg1
                object1.url = url1
                # 二つ目のメッセージを作成
                object2 = AdminChat.new()
                object2.autho_id = 0
                object2.group_id = 3
                object2.message = msg2
                object2.url = url2
                # 保存
                if object1.save and object2.save
                    render :plain => ""
                else
                    render :plain => "Could not save!"
                end
            else
                msg = params["id"] + "さんが大学以外のドメインを使用しました。"
                url = "/autho/chat/command/room?id=" + params["id"]
                # メッセージを作成
                object = AdminChat.new()
                object.autho_id = 0
                object.group_id = 3
                object.message = msg
                object.url = url
                # 保存
                if object1.save and object2.save
                    render :plain => ""
                else
                    render :plain => "Could not save!"
                end
            end
        else
            render :plain => "Token is wrong!"
        end
    end

    def report
        if request.post?
            NotificationMailer.send_report(params["address"]).deliver
            render :plain => ""
        end
    end

end
