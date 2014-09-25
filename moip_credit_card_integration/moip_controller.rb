class MoipController < ApplicationController
  
  # Receives Posts MoIP with changes in status of payments made
  # and updates the payment status of our payment model.
  def nasp
    set_payment_and_nasp

    update_status!(@payment)
    render nothing: true, status: :ok
  end

  # These are Moip NASP params treatment methods
  private

  def set_payment_and_nasp
    @nasp = MyMoip::Nasp.new(params)
    @payment = Payment.find_by_token(@nasp.transaction_id)
  end

  def status
    @nasp.try(:status).try(:to_i)
  end

  def update_status!(payment)
    if PaymentStateMachine::COMPLETED_STATUSES.include?(status)
      confirm_payment!(payment)
    else
      payment.send(PaymentStateMachine::STATUS_ACTION.fetch(status))
    end
  end

  def confirm_payment!(payment)
    nasp_paid_value = @nasp.paid_value.to_i

    if payment.amount == nasp_paid_value
      payment.send(PaymentStateMachine::STATUS_ACTION.fetch(status))
    end
  end
end
