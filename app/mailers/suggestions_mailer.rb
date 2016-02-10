class SuggestionsMailer < ActionMailer::Base
  default from: "questions@uikonf.com",
          bcc: "engin@uikonf.com"
  helper ApplicationHelper
  layout 'mailer'
  
  def new_suggestion(suggestion)
    @suggestion = suggestion
    
    emailObject = @suggestion.proposal.proposer.email
        
    to_address = (emailObject.include? "Hashie::Mash") ? emailObject.scan(/\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\b/i) { |x| puts x } : emailObject
    
    mail to: to_address, subject: "Someone just posted a suggestion on '#{@suggestion.proposal.title}'!"
  end
end