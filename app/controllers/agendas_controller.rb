class AgendasController < ApplicationController
  before_action :set_agenda, only: %i[show edit update destroy]

  def index
    @agendas = Agenda.all
  end

  def new
    @team = Team.friendly.find(params[:team_id])
    @agenda = Agenda.new
  end

  def create
    @agenda = current_user.agendas.build(title: params[:title])
    @agenda.team = Team.friendly.find(params[:team_id])
    current_user.keep_team_id = @agenda.team.id
    if current_user.save && @agenda.save
      redirect_to dashboard_url, notice: 'アジェンダ作成に成功しました！'
    else
      render :new
    end
  end

  def destroy
    if current_user == @agenda.user || current_user == @agenda.team.owner
      if @agenda.destroy
        redirect_to dashboard_path, notice: 'アジェンダ削除しました！'
        @agenda.team.members.each do |user|
          AgendaMailer.agenda_mail(@agenda, user).deliver
        end
      else
        redirect_to dashboard_path, notice: 'アジェンダ削除失敗しました！'
      end
    else
      redirect_to dashboard_path, notice: 'アジェンダは作成者かリーダーしか削除できません！!'
    end
  end

  private

  def set_agenda
    @agenda = Agenda.find(params[:id])
  end

  def agenda_params
    params.fetch(:agenda, {}).permit %i[title description]
  end
end
