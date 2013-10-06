# Working with money

For example, we have a model with a `price` attribute.

## Step 1

The `price` database column **must be an integer**.

## Step 2

Add this to the model:

``` ruby
composed_of :price_money,
  class_name: 'Money',
  mapping: %w(price amount),
  converter: :to_i
```

See the [Rails doc](http://goo.gl/mMqnx) for more info about `composed_of` method.

## Step 3

Copy the *money.rb* file to the *lib* directory.

## Step 4

On your form use the `price_money` instead_of `price`. With twitter bootstrap and slim:

``` ruby
= f.input :price_money do
  .input-group
    span.input-group-addon R$
    = f.input_field :price_money, as: :string, class: :money
```

## Step 5

Use the [maskMoney](http://plentz.github.com/jquery-maskmoney) plugin for jQuery.

``` javascript
$('.money').maskMoney({ thousands: '.', decimal: ',' });
```