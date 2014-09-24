require 'spec_helper'

describe PaymentsController do

  let(:associate) { create :associate }
  
  context "GET 'get_transaction'" do
    it 'successfully' do
      VCR.use_cassette('successfull_moip_get_transaction') do
        sign_in associate.user
        get :get_transaction
        
        expect(Payment.last.token).to_not eql(nil)      
        expect(Payment.last.associate).to eql(associate)      
      end
    end
  end

  context "POST 'moip_callback'" do
    it 'successfully' do
      VCR.use_cassette('successfull_moip_callback') do
        create :payment, token_moip: '9270P104K0B9M1Q6D1P0F3G383O4Y6C9C3N0S070Q050W0R6D1S5X4M3C2L5', status: 0
        sign_in associate.user
        params = {
          "data"=>
            {"Status"=>"EmAnalise", 
             "Codigo"=>"0", 
             "CodigoRetorno"=>"", 
             "TaxaMoIP"=>"0.46", 
             "StatusPagamento"=>"Sucesso", 
             "Classificacao"=>
               {"Codigo"=>"999", 
                "Descricao"=>"Não suportado no ambiente Sandbox"
               }, 
             "CodigoMoIP"=>"280517", 
             "Mensagem"=>"Requisição processada com sucesso", 
             "TotalPago"=>"1.00", 
             "url"=>"https://desenvolvedor.moip.com.br/sandbox/Instrucao.do?token=9270P104K0B9M1Q6D1P0F3G383O4Y6C9C3N0S070Q050W0R6D1S5X4M3C2L5"
            }
          }
        post :moip_callback, params

        expect(Payment.last.codigo_moip).to eql('280517')
        expect(Payment.last.status).to eql(0)
      end
    end
    it 'unsuccessfully' do
      VCR.use_cassette('unsuccessfull_moip_callback') do
        params = {}
        post :moip_callback, params

        expect(response.status).to eq(401)
      end
    end
  end
end