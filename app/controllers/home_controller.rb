class HomeController < ApplicationController
  def index
    flash.keep
    if user_signed_in?
      redirect_to dashboard_path
    else
          if Vestibule.mode_of_operation.mode == :inactive
            redirect_to about_path
          else 
            redirect_to proposals_path
          end
    end
  end

  def anonymous_proposals
  end
end
