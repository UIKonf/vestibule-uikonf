class SuggestionsMailer < ActionMailer::Base
  default from: "questions@uikonf.com",
          bcc: "engin@uikonf.com"
  helper ApplicationHelper
  layout 'mailer'
  
  def new_suggestion(suggestion)
    @suggestion = suggestion
    
    emailObject = @suggestion.proposal.proposer.email
    
    to_address = (emailObject.respond_to?(:email?) && emailObject.email?) ? emailObject.email : emailObject.to_s
    
    mail to: to_address, subject: "Someone just posted a suggestion on '#{@suggestion.proposal.title}'!"
  end
end