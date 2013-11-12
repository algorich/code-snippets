require 'spec_helper'

describe ContactMailer do
  describe 'contact' do
    let(:params) do
      {
        name: 'Fulano',
        email: 'fulano@gmail.com',
        message: 'Qq coisa',
        to: 'TODO:@change-me.com'
      }
    end

    let(:mail) { ContactMailer.contact(params) }

    it 'guarantee that the receiver is correct' do
      mail.to.should == [params[:to]]
    end

    it 'guarantee that the sender is correct' do
      mail.from.should == ['contato@engep2013.com.br']
    end

    it 'guarantee that the subject is correct' do
      mail.subject.should == '[Contact] TODO: change-me'
    end

    it 'guarantee that all information appears on the email body' do
      mail.body.encoded.should =~ /Nome: #{params[:name]}/
      mail.body.encoded.should =~ /E-mail: #{params[:email]}/
      mail.body.encoded.should =~ /Mensagem:\r\n#{params[:message]}/
    end
  end
end

