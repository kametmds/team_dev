class AgendaMailer < ApplicationMailer
  def agenda_mail(agenda, user)
    @agenda = agenda
    mail to: "#{user.email}", subject: "アジェンダ削除通知メール"
  end
end
