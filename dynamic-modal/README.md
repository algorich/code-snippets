# Dynamic modal

It's used to render dynamic content on a default modal

## Step 1:

Insert the modal on your `application.html.slim`, you can use the code bellow:

```html
.modal.fade
  .modal-dialog
    .modal-content
      .modal-header
        button.close type="button" data-dismiss="modal" aria-hidden="true" &times
        h4.modal-title
      .modal-body
```

Now it can be used globally on your project.


## Step 2:

You need a remote link to send an ajax request:

```ruby
= link_to 'Novo', new_person_path, remote: true
```


## Step 3:

You need a controller/action that responds to this ajax call:

```ruby
class Person < ApplicationController
  def new
    @person = Person.new
  end
end
```

All that you need to be rendered on the modal can be initialized right there.

## Step 4:

When the ajax call executes the new action, it will look for a new.js.erb
view to render the content initialized on the action.

To render content on the modal and show it up, you can use the code above.

Obs: It's rendering the `person_fields` partial.

```
var $modal = $('.modal');

$modal.find('.modal-title').text('Novo atleta');

$modal.find('.modal-body').
  html("<%= escape_javascript(render 'person_fields' %>");

$modal.modal('show');
```

And that's it, you can improve it by creating a action to save the rendered form on
modal, or just use it to render dynamic content for each opened link.




