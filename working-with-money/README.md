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
  converter: :from_s

def price_in_cents
  read_attribute(:price) || 0
end

def price
  price_in_cents / 100.0
end
```

See the [Rails doc](http://goo.gl/mMqnx) for more info about `composed_of` method.

## Step 3

Copy the *money.rb* file to the *lib* directory.

## Step 4

On your form use the `price_money` instead_of `price`. With twitter bootstrap and slim:

``` text
= f.input :price_money do
  .input-group
    span.input-group-addon R$
    = f.input_field :price_money, as: :string, class: :money
```

## Step 5

Use the [maskMoney](http://plentz.github.com/jquery-maskmoney) plugin for jQuery.

``` javascript
$(function () {
    var $money_inputs = $('.money');
    $money_inputs.maskMoney({ allowZero: true, thousands: '.', decimal: ',' });
    $money_inputs.maskMoney('mask'); // apply the mask for already filled inputs
});
```

## Step 6

Remember to add i18n for `price_money` attribute and add it to the permitted params on controller.

## Step 7

The specs:

``` ruby
it 'price_money' do
  model = create :model

  model.price_money = '743,40'
  expect(model.price).to eq(74340)

  model.update_attribute(:price_money, '1.543,21')
  expect(model.price).to eq(154321)
end
```