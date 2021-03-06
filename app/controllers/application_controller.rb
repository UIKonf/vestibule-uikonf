class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user, :user_signed_in?, :can?
  before_filter :set_archive_mode_warning_if_required

  private

  def authenticate_user!
    unless current_user
      flash[:alert] = "You need to sign in or sign up before continuing."
      session[:user_id] = nil
      redirect_to root_url
    end
  end

  def user_signed_in?
    current_user.present?
  end

  def current_user
    @current_user ||= User.find_by_id(session[:user_id]) if session[:user_id]
  end

  def can?(action, object)
    Vestibule.mode_of_operation.can?(action, object)
  end

  def set_archive_mode_warning_if_required
    if Vestibule.mode_of_operation.mode == :archive
      flash.now[:archive] = 'This version of Vestibule is <em>read only</em>. It represents an archive of the community effort to produce content for <a href="http://www.uikonf.com/">UIKonf 2018</a>.'.html_safe
    end
    if Vestibule.mode_of_operation.mode == :inactive
      flash.now[:archive] = 'Vestibule is not open for proposals yet. Follow <a href="https://twitter.com/uikonf">@uikonf</a> in order to be notified when it is turned on.'.html_safe
    end

  end
end
