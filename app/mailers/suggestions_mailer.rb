class SuggestionsMailer < ActionMailer::Base
  default from: "questions@uikonf.com",
          bcc: "engin@uikonf.com"
  helper ApplicationHelper
  layout 'mailer'
  
  def new_suggestion(suggestion)
    @suggestion = suggestion
    
    email = @suggestion.proposal.proposer.email
    to_address =
      if email.respond_to?(:[])
        to_address = email[:email]
      else 
        to_address = email
      end
    
    mail to: to_address, subject: "Someone just posted a suggestion on '#{@suggestion.proposal.title}'!"
  end
end