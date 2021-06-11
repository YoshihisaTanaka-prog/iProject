class NotificationMailer < ApplicationMailer
    default from: "geek.entre01@gmail.com"
  
    def send_report(r_obj,s_obj,t_obj)
      @report = r_obj
      @student = s_obj
      @teacher = t_obj
      mail(
        subject: @student.userName + "さんの" + "授業報告", #メールのタイトル
        to: @student.parentEmailAdress #宛先
      ) do |format|
        format.text
      end
    end
end
