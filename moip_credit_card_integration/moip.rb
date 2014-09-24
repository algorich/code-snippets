# Class used to handle MOIP behavior on the app.

class Moip
  TIMEOUT = 20 #seconds

  def initialize(payment)
    @payment = payment
  end

  def get_transaction  
    instruction_params = {
      id: @payment.token,
      payment_reason: 'Pagamento de Anuidade' ,
      values: [@payment.amount],
      payer: build_payer
    }

    instruction = MyMoip::Instruction.new(instruction_params)
    request = MyMoip::TransparentRequest.new(@payment.id)
    request.api_call(instruction, timeout: TIMEOUT)
    request
  end

  def build_payer
    user = @payment.user

    MyMoip::Payer.new(
      id:                     user.id,
      name:                   user.name,
      email:                  user.email,
      address_street:         user.street,
      address_street_number:  user.number,
      address_street_extra:   user.complement,
      address_neighbourhood:  user.neighborhood,
      address_city:           user.city,
      address_state:          user.uf,
      address_country:        'BRA',
      address_cep:            user.postal_code,
      address_phone:          user.phone
    )
  end
end
