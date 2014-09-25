// Makes a ajax action get_transaction to sending card data
$(function (){
  $('#submit-payment').on('click', function(){
    $('#submit-payment').prop('disabled', true);
    $.ajax({
      url: "/get_transaction",
      method: 'GET',
      }).success(function(data) {
        $('#MoipWidget').attr('data-token', data['token'])
        send_moip_payment(build_payment_object())
    });
  })
})

// Creates the data structure of payment as requested by MoIP
function build_payment_object(){
  return {
    "Forma": "CartaoCredito",
    "Parcelas": "1",
    "CartaoCredito": {
        "Numero": $('#payment_card_number').val(),
        "Expiracao": $('#payment_expiration_date').val().replace(new RegExp(" ", "g"), ""),
        "CodigoSeguranca": $('#payment_safe_code').val(),
        "Portador": {
            "Nome": $('#payment_owner_name').val(),
            "DataNascimento": $('#payment_owner_birthday').val(),
            "Telefone": $('#payment_owner_phone').val(),
            "Identidade": $('#payment_owner_cpf').val() 
        }
    }
  }
}

// Sends the data to the MoIP
send_moip_payment = function(settings){ 
  MoipWidget(settings);
}

// Function that receives the return of MoIP when the transaction was successful
function success_moip_request(data){
  $.ajax({
      url: "/moip_callback",
      method: 'POST',
      data: ({data: data})
      }).success(function(data) {
        if(data == 'success'){
          location.reload();
        }
    });
}

// function that receives the return of MoIP when the transaction was wrong
function failure_moip_request(data){
  $('#submit-payment').prop('disabled', false);
  $('#moip-errors').html("")
  if (data['Mensagem'] == null){
    $.each( data, function(key, value){
      $('#moip-errors').append('<p>'+value['Mensagem']+'</p>');
    } )
  }else{
    $('#moip-errors').append('<p>'+data['Mensagem']+'</p>');
  }
}