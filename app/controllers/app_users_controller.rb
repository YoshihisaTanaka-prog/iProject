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

    def report_mail
        if request.post? and check_token(params["token"])
            ncmb_report_object = NCMB::DataStore.new "Report"
            report_object = ncmb_report_object.where("objectId", params["id"]).first

            ncmb_student_object = NCMB::DataStore.new "StudentParameter"
            student_object = ncmb_student_object.where("userId", report_object.studentId).first

            ncmb_teacher_object = NCMB::DataStore.new "TeacherParameter"
            teacher_object = ncmb_teacher_object.where("userId", report_object.teacherId).first

            if student_object.parentEmailAdress.blank?
                render :plain => "Address Error"
            else
                NotificationMailer.send_report(report_object, student_object, teacher_object).deliver
                render :plain => "Sent email"
            end
        else
            render :plain => "Token Error"
        end
    end

    def report_object
        if request.post? and check_token(params["token"])
            object = Report.new()
            object.class_name = params["className"]
            object.object_id = params["objectId"]
            object.user_id = params["userId"]
            if object.save
                render :plain => "Successed"
            else
                render :plain => "Failed"
            end
        else
            render :plain => "Token Error"
        end
    end

    def user
        if request.post? and check_token(params["token"])
            object = User.new()
            object.user_id = params["userId"]
            object.role = params["role"]
            if object.save
                render :plain => "Successed"
            else
                render :plain => "Failed"
            end
        else
            render :plain => "Token Error"
        end
    end

end
