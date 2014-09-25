# Class used to handle MOIP behavior on the app.

class Moip
  TIMEOUT = 20 #seconds

  # The payment object should have a relationship with a user model that should have the necessary 
  # fields to create a Moip Payer
  
  def initialize(payment)
    @payment = payment
  end

  # Creates a Moip Instruction object that contains payment data and payer data,
  # makes a request to Moip that responds with status and token.
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

  # Creates and returns a Moip Payer object
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
