class PaymentsController < ApplicationController

  def get_transaction
    @payment = Payment.create associate: current_user.userable, amount: 1, status: 0
    moip = Moip.new @payment
    response = moip.get_transaction
    if response.success?
      @payment.update_attributes(token_moip: response.token)
      render json: { token: response.token }
    end
  end

  def moip_callback
    token = /token=(.+)/.match(params['data']['url'])[1]
    payment = Payment.find_by_token_moip(token)
    payment.update_attributes(
      codigo_moip: params['data']['CodigoMoIP']
      )
    render json: :success
  end
end