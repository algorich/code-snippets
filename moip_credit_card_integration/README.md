# Moip Credit Card Integration

Implement checkout transparent with moip

### Step 1 
  
  Add moip gem in your Gemfile 

  ``` ruby
  gem 'mymoip', git: 'https://github.com/algorich/mymoip', branch: 'master'
  ```
  
  In your terminal, run bundle


### Step 2 
  
  Register in Moip site and get sandbox token and key

  - visit https://desenvolvedor.moip.com.br/sandbox/cadastro/integracao and register
  - login in https://labs.moip.com.br/login/
  - click in 'Ferramentas' 
  - in side menu click in 'API MoIP' 
  - click in option 'clique aqui' in '1) Cadastre o serviço. [clique aqui]''
  - click in 'Ferramentas' -> API MoIP -> Chaves de Acesso
  - note sandbox Token de acesso and Chave de acesso

### Step 3

  Copy and configure moip_configuration.rb file

  add the following line in /config/application.rb and change host value to your application domain
  
  ``` ruby
  config.action_mailer.default_url_options = { host: "example.com" }
  ```
  - copy moip_configuration.rb to /config/initializers/
  - edit the value yourApplicationName in line MyMoip.default_referer_url and fill MyMoip.sandbox_token with Token de acesso and MyMoip.sandbox_key with Chave de acesso

### Step 4

  Copy model Moip and edit your values 
  
  - copy moip.rb to lib/
  - add config.autoload_paths += %W(#{config.root}/lib) in config/application.rb
  - edit the values in build_payer method, the field address_state must be a UF 
  - in get_transaction method, the id attribute should receive a single value related to a payment object.

### Step 5
  
  Create moip routes 

  ``` ruby
  get  '/get_transaction'  => 'payments#get_transaction', as: :get_transaction, constraints: { format: :js }
  post '/moip_callback'    => 'payments#moip_callback',   as: :moip_callback, constraints: { format: :js }
  get  '/payment'        => 'payments#payment',           as: :payment 
  ```

### Step 6 

  Create paymentController

  - Copy the file payments_controller.rb to app/controllers
  - In action get_transaction, edit the required values​​, remember that Moip.new must receive a payment object with the token attribute filled, have a relationship with a user model and have the attributes token_moip, codigo_moip and status starting with 0.

### Step 7

  Create view and js

  - create a payments folder in app/views/ 
  - copy the file payment.html.slim to app/views/payments/ 
  - copy the file _moip.html.slim to app/views/payments/
  - copy the file payment.js to app/assets/javascripts/

### Step 8 

  Test

  Add vcr gem in your Gemfile 

  ``` ruby
  gem 'vcr', '~> 2.6.0'
  ```  
  In your terminal, run bundle  

  - copy the file payments_controller_spec to app/spec/controllers/
  - copy the file moip_spec to app/spec/lib/


##Implement NASP

Nasp is one of the means provided by MoIP for transaction tracking , it sends an automatic notification via an HTTP POST.

### Step 1

Create NASP route

add the following line to your routes file

``` ruby
post '/moip/nasp/',  to: 'moip#nasp'
```

### Step 2

Create moip Controller

Copy the file moip_controller.rb to app/controllers/

### Step 3

Create state machine

- copy payment_state_machine.rb to lib/
- copy payment_scopes.rb to lib/
- change after_transition in payment_state_machine.rb, to make the changes that occur when the payment is approved.

### Step 4

Test

copy the file moip_controller_spec to app/spec/controllers/
