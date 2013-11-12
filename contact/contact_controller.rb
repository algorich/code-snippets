class ContactController < ApplicationController
  def new
    @contact_form = Contact.new
  end

  def send
    @contact_form = Contact.new(params[:contact])

    if @contact_form.save
      redirect_to(new_contact_path, notice: 'Mensagem enviada com sucesso.')
    else
      render action: :new
    end
  end
end