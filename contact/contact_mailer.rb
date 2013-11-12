class ContactMailer < ActionMailer::Base
  def contact(params={})
    @name = params[:name]
    @email = params[:email]
    @message = params[:message]
    @to = params[:to]

    mail(from: 'TODO:@change-me.com',
         to: @to,
         repond_to: @email,
         subject: "[Contact] TODO: change-me",
         content_type: 'text/plain')
  end
end

