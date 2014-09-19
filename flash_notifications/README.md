# Flash notification

This snippet is used to generate custom flash notifications.

## Step 1:

Create a `notification_helper.rb` with the code above

```ruby
module NotificationHelper
  # Inspired by https://github.com/seyhunak/twitter-bootstrap-rails/blob/master/app/helpers/bootstrap_flash_helper.rb
  def flash_notifications(options = {})
    flash_messages = []

    flash.each do |type, message|
      # Skip empty messages, e.g. for devise messages set to nothing in a locale file.
      next if message.blank?

      # Converting default types
      type = type.to_sym
      type = :success if type == :notice
      type = :danger  if type == :alert
      type = :danger  if type == :error

      Array(message).each do |msg|
        text = content_tag(:div,
          content_tag(:button, raw("&times;"), :class => "close", "data-dismiss" => "alert") +
          msg, :class => "alert fade in alert-#{type} #{options[:class]}")
        flash_messages << text if msg
      end
    end

    flash_messages.join("\n").html_safe
  end
end
```

## Step 2:

Put `<%= flash_notifications %>` in your layout