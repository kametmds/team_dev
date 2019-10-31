class TeamMailer < ApplicationMailer
  def team_mail(owner)
    @owner = owner

    mail to: "#{@owner.email}", subject: "確認メール"
  end
end
