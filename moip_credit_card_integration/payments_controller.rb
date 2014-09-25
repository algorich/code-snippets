class PaymentsController < ApplicationController

  # Creates a payment object and makes a request to MoIP to get the 
  # token and updates the payment with the token received. 
  def get_transaction
    @payment = Payment.create associate: current_user.userable, amount: 1, status: 0
    moip = Moip.new @payment
    response = moip.get_transaction
    if response.success?
      @payment.update_attributes(token_moip: response.token)
      render json: { token: response.token }
    end
  end

  # Updates the payment object with the Payment Code MoIP
  def moip_callback
    token = /token=(.+)/.match(params['data']['url'])[1]
    payment = Payment.find_by_token_moip(token)
    payment.update_attributes(
      codigo_moip: params['data']['CodigoMoIP']
      )
    render json: :success
  end
end