class NotificationMailer < ApplicationMailer
    default from: "geek.entre01@gmail.com"
  
    def send_report(mail_address)
      mail(
        subject: "授業報告", #メールのタイトル
        to: mail_address #宛先
      ) do |format|
        format.text
      end
    end
end
