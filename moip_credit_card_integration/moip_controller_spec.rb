require 'spec_helper'

def update_moip_attributes_stub
  moip = double('Moip')
  expect(Moip).to receive(:new).with(@payment) { moip }
  expect(moip).to receive(:force_update_payment_info!) { '173727' }
end

describe MoipController do
  context 'nasp' do
    before(:each) do
      @associate  = create :associate
      @payment    = create :payment, amount: 850

      # credit card
      @nasp_credit_card_params = {
        id_transacao: @payment.token,
        cofre: '448dcf01-0801-48d3-b9aa-8a86fbbd8914',
        forma_pagamento: '37',
        recebedor_login: 'vivabemsim',
        cartao_bin: '234567',
        valor: '5000',
        cod_moip: '173727',
        tipo_pagamento: 'CartaoDeCredito',
        email_consumidor: @associate.user.email,
        parcelas: '1',
        cartao_bandeira: 'Visa',
        cartao_final: '6789'
      }
    end

    context 'should change payment status' do
      it 'authorized payment' do
        update_moip_attributes_stub

        post :nasp, @nasp_credit_card_params.merge(status_pagamento: '1',
                                                   valor: '850')

        expect(@payment.reload.status).to eq(Payment.status(:authorized))
        expect(@payment.reload.wallet_transaction).to_not eq(nil)
        expect(@payment.reload.wallet_transaction.amount).to eq(@payment.amount)
        expect(@payment.reload.wallet_transaction.is_out?).to eq(true)

      end
      it 'done payment' do
        update_moip_attributes_stub

        post :nasp, @nasp_credit_card_params.merge(status_pagamento: '4',
                                                   valor: '850')

        expect(@payment.reload.status).to eq(Payment.status(:done))
        expect(@payment.reload.wallet_transaction).to_not eq(nil)
        expect(@payment.reload.wallet_transaction.amount).to eq(@payment.amount)
        expect(@payment.reload.wallet_transaction.is_out?).to eq(true)

      end
      it 'authorized payment cant be canceled' do
        @payment.update(status: Payment.status(:authorized))

        post :nasp, @nasp_credit_card_params.merge(
          status_pagamento: '5', # canceled
          valor: '850')

        expect(@payment.reload.status).to eq(Payment.status(:authorized))
      end
      it 'failure' do
        post :nasp, @nasp_credit_card_params.merge(status_pagamento: '4',
                                                   valor: '750')

        expect(@payment.reload.status).not_to eq(Payment.status(:done))
        expect(@payment.amount).to eq(850)
      end
      it 'reversed payment' do
        @payment.update(status: Payment.status(:done))

        post :nasp, @nasp_credit_card_params.merge(status_pagamento: '7')

        expect(@payment.reload.status).to eq(Payment.status(:reversed))
      end
      it 'canceled payment' do
        post :nasp, @nasp_credit_card_params.merge(status_pagamento: '5')

        expect(@payment.reload.status).to eq(Payment.status(:canceled))
      end

      it 'payment_slip_impressed' do
        post :nasp, @nasp_credit_card_params.merge(status_pagamento: '3',
                                                   valor: '100')
        expect(@payment.reload.status).to eq(Payment.status(:payment_slip_impressed))
      end

      it 'under_analysis' do
        post :nasp, @nasp_credit_card_params.merge(status_pagamento: '6',
                                                   valor: '850')
        expect(@payment.reload.status).to eq(Payment.status(:under_analysis))
      end
    end
  end
end