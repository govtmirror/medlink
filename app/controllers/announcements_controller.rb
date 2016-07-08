class AnnouncementsController < ApplicationController
  def index
    reaches = AnnouncementReachCache.new
    @announcements = policy_scope(Announcement).
       order(last_sent_at: :desc).
       includes(:country).
       map { |ann| AnnouncementPresenter.new ann, reaches: reaches }
  end

  def new
    ann = Announcement.new country: current_user.country
    @announcement = AnnouncementForm.new ann, announcer: current_user
    authorize @announcement
  end

  def create
    ann = Announcement.new country: current_user.country
    @announcement = AnnouncementForm.new ann, announcer: current_user
    if save_form @announcement, params[:announcement]
      redirect_to announcements_path, notice: I18n.t!("flash.announcement.created")
    else
      render :new
    end
  end

  def edit
    @announcement = AnnouncementForm.new Announcement.find(params[:id]), announcer: current_user
    authorize @announcement
  end

  def update
    @announcement = AnnouncementForm.new Announcement.find(params[:id]), announcer: current_user
    if save_form @announcement, params[:announcement]
      redirect_to announcements_path, notice: I18n.t!("flash.announcement.updated")
    else
      render :edit
    end
  end

  def deliver
    announcement = AnnouncementPresenter.new Announcement.find params[:id]
    authorize announcement
    announcement.send!
    redirect_back fallback_location: announcements_path, notice: I18n.t!("flash.announcement.sent", volunteer_count: announcement.reach)
  end

  def destroy
    announcement = Announcement.find params[:id]
    authorize announcement
    announcement.hide
    redirect_back fallback_location: announcements_path, notice: I18n.t!("flash.announcement.deleted")
  end
end
