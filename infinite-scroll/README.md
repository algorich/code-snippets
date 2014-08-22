# infinite-button-scroll

This snippet is used to generate an infinite scroll on the view.

## Dependencies

- [kaminari](https://github.com/amatsuda/kaminari)
- [jQuery](http://jquery.com/)

### Optional

Those examples are using [slim templates](http://slim-lang.com/)

## Step 1:

In your controller action you should add the kaminari pagination method `page` in your collection, this method will show only 10 objects by default.

```slim
def index
  @collection = Collection.page(params[:page])
end
```

## Step 2 (view):

Your collection view iteration should look like this:

```slim
#alg-content
  #alg-collection-list
    = render 'collection', collection: @collection

  = next_page_link(@collection)
```

```slim
// _collection.html.slim
- collection.each do |item|
  = item
```


The `next_page_link` helper method:

```slim
def next_page_link(scope)
  url = action_path(params.merge(page: scope.next_page))

  if scope.next_page
    link = link_to('Carregar Mais', url, remote: true, data: { disable_with: 'Loading...' } )

    return content_tag(:p, link, id: 'alg-next-page')
  end

  return nil
end
```

The `action_path` is the route to `collection` action.

## Step 3

You need a collection.js.erb to respond the remote js request:

```javascript
$('#alg-collection-list').append('<%= j(render partial: "collection_partial", locals: { collection: @collection } )%>');
$('#alg-next-page').replaceWith('<%= next_page_link(@collection) %>')
```