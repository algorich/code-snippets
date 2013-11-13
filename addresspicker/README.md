# Addresspicker with google maps

**NOTE**: The views are using slim.

## Step 1

Get [jquery addresspicker](https://github.com/sgruhier/jquery-addresspicker).

## Step 2

Add this `yield` lines to include javascripts before and after the application.js.

```
= yield :javascripts_before_application
= javascript_include_tag 'application'
= yield :javascripts_after_application
```

## Step 3

On the view that you will use the addresspicker, add this:

```
= content_for :javascripts_before_application do
  script src="https://maps.googleapis.com/maps/api/js?sensor=false"
= content_for :javascripts_after_application do
  = javascript_include_tag 'jquery.ui.addresspicker'
```

## Step 4

Add the fields to the form. The address is required and the `data-lat` and `data-lng` are the center of the map. The other fields you add as you wish.

```
= f.input :address, as: :string,\
  input_html: { id: :addresspicker,\
    'data-lat' => f.object.latitude,\
    'data-lng' => f.object.longitude }

= f.input :latitude, as: :hidden, input_html: { id: :lat }
= f.input :longitude, as: :hidden, input_html: { id: :lng }

#adresspicker-map
```

## Step 5

Copy the *addresspicker.js* to your *app/assets/javascripts* directory and require it on *application.js* (only if you are not using "require tree"). Remember to ajust for your use case. For more info, see the [jquery addresspicker documentation](https://github.com/sgruhier/jquery-addresspicker).


## Step 6

You must add the `jquery-ui-rails` to your *Gemfile*

``` ruby
gem 'jquery-ui-rails'
```

Required the addresspicker dependencies on *application.js*

``` javascript
// addresspicker dependencies
//= require jquery.ui.core
//= require jquery.ui.widget
//= require jquery.ui.autocomplete
```

And the jquery ui css on *application.css*

``` css
**= require jquery.ui.autocomplete
```

## Step 7

Add a style for your map. **The `widh` and `height` are required!**.

``` css
/*
** Address picker
*/

#adresspicker-map {
  /* required */
  width: 300px;
  height: 300px;

  /* extra */
  border: 1px solid #DDD;
  margin: 10px 0 10px 0;
  -webkit-box-shadow: #AAA 0px 0px 15px;
}
```


## Step 8

Add the *jquery.ui.addresspicker.js* to the precompile additional assets at *config/enviroments/production.rb* (and staging if it applies):

``` ruby
config.assets.precompile += %w( jquery.ui.addresspicker.js )
```


## Step 9

Test it using capybara and poltergeist:

```
scenario 'add address', js: true do
  find('#addresspicker').set 'Campos dos Goytacazes'
  page.execute_script("$('#addresspicker').trigger('keydown')")
  find('li.ui-menu-item a').click

  expect(find('#state', visible: false).value).to eq('Rio de Janeiro')
  expect(find('#city', visible: false).value).to eq('Campos dos Goytacazes')
end
```

## Step 10

For more information about the fields and more, see [jquery addresspicker](https://github.com/sgruhier/jquery-addresspicker) documentation.