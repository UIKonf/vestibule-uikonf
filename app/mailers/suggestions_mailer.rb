class SuggestionsMailer < ActionMailer::Base
  default from: "questions@uikonf.com",
          bcc: "engin@uikonf.com"
  helper ApplicationHelper
  layout 'mailer'
  
  def new_suggestion(suggestion)
    @suggestion = suggestion
    
    to_address = ''
    if @suggestion.proposal.proposer.email.is_a?(Hash)
      to_address = @suggestion.proposal.proposer.email[:email]
    else 
      to_address = @suggestion.proposal.proposer.email
    end
    
    mail to: to_address
         subject: "Someone just posted a suggestion on '#{@suggestion.proposal.title}'!"
  end
end