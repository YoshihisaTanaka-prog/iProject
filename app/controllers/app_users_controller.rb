class AppUsersController < ApplicationController

    skip_before_action :verify_authenticity_token

    def new_domain(p, d)
        msg1 = p + "さんが未確認のドメインを使用しました。"
        msg2 = d + "というドメインです。"
        url1 = "/autho/chat/command/room?id=" + p + "&autoType=1"
        url2 = "/autho/domain?dom=" + d
        # 一つ目のメッセージを作成
        object1 = AdminChat.new()
        object1.autho_id = 0
        object1.group_id = 3
        object1.message = msg1
        object1.url = url1
        object1.save
        # 二つ目のメッセージを作成
        object2 = AdminChat.new()
        object2.autho_id = 0
        object2.group_id = 3
        object2.message = msg2
        object2.url = url2
        object2.save
    end
    
    def wrong_domain(p)
        msg = p + "さんが大学以外のドメインを使用しました。"
        url = "/autho/chat/command/room?id=" + p + "&autoType=1"
        # メッセージを作成
        object = AdminChat.new()
        object.autho_id = 0
        object.group_id = 3
        object.message = msg
        object.url = url
        # 保存
        object.save
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
            object = User.find_by(user_id: params["userId"])
            if object.blank?
                object = User.new()
                object.user_id = params["userId"]
                object.role = params["role"]
                object.parameter_id = params["paramId"]

                if !params["domain"].blank?
                    object.domain = params["domain"]
                    domain_object = NCMB::DataStore.new "Domain"
                    domain = domain_object.where("domain", params["domain"]).first
                    if domain.blank?
                        new_domain(params["paramId"], params["domain"])
                    elsif !domain.checked
                        new_domain(params["paramId"], params["domain"])
                    elsif !domain.permitted
                        wrong_domain(params["paramId"])
                    end
                end

                object.last_sent_time = DateTime.now
                if object.save
                    render :plain => "Successed"
                else
                    render :plain => "Failed"
                end
            else
                object.last_sent_time = DateTime.now
                object.unread_count += 1
                if object.save
                    render :plain => "Successed"
                else
                    render :plain => "Failed"
                end
            end
        else
            render :plain => "Token Error"
        end
    end

end
