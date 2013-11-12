require 'spec_helper'

feature 'Send a contact message' do

  before(:each) do
    ActionMailer::Base.deliveries.clear
    visit new_contact_path
  end

  scenario 'successfully' do
    fill_in 'Nome', :with => 'Fulano'
    fill_in 'E-mail', :with => 'fulano@gmail.com'
    fill_in 'Mensagem', :with => 'Mensagem qualquer'
    click_button 'Enviar mensagem'
    expect(page).to have_content('Mensagem enviada com sucesso.')
    ActionMailer::Base.deliveries.count.should == 1
  end

  scenario 'failure' do
    fill_in 'Nome', :with => ''
    fill_in 'E-mail', :with => 'fulano@gmail'
    fill_in 'Mensagem', :with => ''
    click_button 'Enviar mensagem'
    expect(page).to have_content('Nomenão pode ser vazio.')
    expect(page).to have_content('E-mailformato inválido.')
    expect(page).to have_content('Mensagemnão pode ser vazio.')
    ActionMailer::Base.deliveries.count.should == 0
  end
end
