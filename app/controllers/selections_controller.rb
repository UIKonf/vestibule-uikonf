class SelectionsController < ApplicationController
  before_filter :authenticate_user!, :except => [:index]
  before_filter :check_mode_of_operation_for_viewing, only: [:index]
  before_filter :check_mode_of_operation_for_selection, only: [:create, :destroy]

  def index
    if can?(:see, :agenda)
      @top_proposals = Selection.popular.select { |count, proposal| proposal.confirmed? }.take(8)
    end
    if current_user && can?(:make, :selection)
      begin
        randomized_proposal_ids = session[:randomized_proposals_ids]
      
        if randomized_proposal_ids == nil 
          @proposals = Proposal.available_for_selection_by(current_user).shuffle  
          session[:randomized_proposals_ids] = @proposals.map{ |p| p[:id]}   
        else 
          unsorted_proposals = Proposal.find_all_by_id(randomized_proposal_ids).reject { |p| Selection.where(proposal_id: p.id, user_id: user.id).exists? }.group_by(&:id)
          @proposals = randomized_proposal_ids.map { |i| unsorted_proposals[i].first }
        end
      rescue Exception => e 
        logger.debug "caught an exception:" + e.message
        logger.debug e.backtrace.inspect
        @proposals = Proposal.available_for_selection_by(current_user)
      end
    end
  end

  def create
    selection = current_user.selections.build(params[:selection])
    if selection.save
      redirect_to selections_path
    else
      redirect_to selections_path, alert: selection.errors.full_messages.to_sentence
    end
  end

  def destroy
    selection = current_user.selections.find(params[:id])
    selection.destroy
    redirect_to selections_path
  end

  private
  def check_mode_of_operation_for_viewing
    unless can?(:see, :selection) || can?(:see, :agenda)
      flash[:alert] = "In #{Vestibule.mode_of_operation.mode} mode you cannot vote for proposals or see the generated agenda."
      redirect_to dashboard_path
    end
  end

  def check_mode_of_operation_for_selection
    unless can?(:make, :selection)
      flash[:alert] = "In #{Vestibule.mode_of_operation.mode} mode you cannot vote for proposals."
      redirect_to dashboard_path
    end
  end
end
