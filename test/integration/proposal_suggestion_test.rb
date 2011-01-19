require "test_helper"

class ProposalSuggestionTest < IntegrationTestCase

  context "Given a talk proposal" do
    setup do
      @proposer = Factory(:account)
      @proposal = Factory(:proposal, :proposer => @proposer.user)
    end

    context "a visitor viewing the proposal" do
      should "not be able to suggest anything"
    end

    context "a logged in user viewing the proposal" do
      setup do
        @account = Factory(:account)
        sign_in @account
        visit proposal_path(@proposal)
      end

      should "be able to make a suggestion about the proposal" do
        fill_in "Suggestion", :with => "I think you should focus on the first bit"
        click_button "Create Suggestion"

        within ".suggestions" do
          i_can_see_the_gravatar_for_account @account
          assert page.has_content?("I think you should focus on the first bit")
        end
      end
    end

  end

end