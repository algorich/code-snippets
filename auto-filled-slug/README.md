# Auto filled slug

This snippet is used to auto fill a slug input based on another input (for example a name input).

## Step 1

Download and add the [SpeakingURL](http://pid.github.io/speakingurl/) js lib to your project.

## Step 2

The slug input should have a `data-auto-fill-slug` attribute with value `true` or `false`. This attribute indicates if the slug should be auto filled or not. Generally, you want to auto fill the slug when creating a new entity and don't when editing. In a Rails app you can use a `@entity.new_record?` to set the value.

Add the class `slug-auto-filled` to the slug input and the class `base-for-slug` to the input that is the base for the auto fill.

``` erb
<%= f.input :name, input_html: { class: 'base-for-slug' } %>

<%= f.input :slug, input_hmtl: {
                    class: 'slug-auto-filled',
                    'data-auto-fill-slug' => @entity.new_record? } %>
```

## Step 3

Add this javascript:

``` javascript
/*
** Auto filled slug
*/

$(function() {
    var $slug_input = $('.slug-auto-filled'),
        $base_input = $('.base-for-slug');

    $base_input.on('input', function(e) {
        if ($slug_input.data('auto-fill-slug') === true)
            $slug_input.val(getSlug($(this).val()));
    });
});
```