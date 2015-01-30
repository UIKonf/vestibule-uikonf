class SuggestionsMailer < ActionMailer::Base
  default from: "questions@uikonf.com",
          bcc: "engin@uikonf.com"
  helper ApplicationHelper
  layout 'mailer'
  
  def new_suggestion(suggestion)
    @suggestion = suggestion

    mail to: @suggestion.proposal.proposer.email,
         subject: "Someone just posted a suggestion on '#{@suggestion.proposal.title}'!"
  end
end