# Contact page

This is not only for contact page. The idea can be used for any form with validation that should not be saved on database.

## Copy the files

``` bash
cp contact_controller.rb <path-to-your-project>/app/controllers
cp contact.rb <path-to-your-project>/app/models
cp contact.text.erb <path-to-your-project>/app/views/contact_mailer
cp contact_mailer_spec.rb <path-to-your-project>/spec/mailers
cp contact_spec.rb <path-to-your-project>/spec/features
```

## Change for your fit

grep for "TODO:" and change for your fit.

``` bash
grep -rn 'TODO:' .
```

## Get the routes

Paste on your routes:

``` ruby
  # contact
  get   '/contact' => 'contact#new',  as: :contact
  post  '/contact' => 'contact#send_it', as: :send_contact
```

## Create the contact form

``` erb
<%= simple_form_for @contact_form, url: send_contact_path do |f| %>
  <%= f.input :name %>
  <%= f.input :email %>
  <%= f.input :message, as: :text %>

  <%= f.button :submit, 'Enviar mensagem' %>
<% end %>
```

## Fix the specs

Fix the specs for your fit and make it pass.