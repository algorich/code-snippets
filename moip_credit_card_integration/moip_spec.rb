require 'spec_helper'

describe Moip do
    before(:each) do
      @payment = create :payment
      @associate = @payment.associate
    end
  it '#payer' do

    moip_associate = Moip.new(@payment).build_payer

    expect(moip_associate.class).to eq(MyMoip::Payer)
    expect(moip_associate.id).to eq(@associate.id)
    expect(moip_associate.name).to eq(@associate.name)
    expect(moip_associate.email).to eq(@associate.user.email)
    expect(moip_associate.address_street).to eq(@associate.address.street)
    expect(moip_associate.address_street_number).to eq(@associate.address.number)
    expect(moip_associate.address_street_extra).to eq(@associate.address.complement)
    expect(moip_associate.address_neighbourhood).to eq(@associate.address.neighborhood)
    expect(moip_associate.address_city).to eq(@associate.address.city)
    expect(moip_associate.address_state).to eq(@associate.address.uf)
    expect(moip_associate.address_cep).to eq(@associate.address.postal_code)
    expect(moip_associate.address_phone).to eq(@associate.address.phone)
    expect(moip_associate.address_country).to eq('BRA')
  end

  context '#get_transaction' do
    it 'with success' do
      request = Moip.new(@payment).get_transaction
      expect(request.class).to eq(MyMoip::TransparentRequest)
      expect(request.token).to_not be_nil
    end

    it 'unsuccessfully to have two payments with equals ids' do
      Moip.new(@payment).get_transaction
      request = Moip.new(@payment).get_transaction
      expect(request.token).to be_nil 
      expect(request.success?).to eq(false)
    end
  end
end