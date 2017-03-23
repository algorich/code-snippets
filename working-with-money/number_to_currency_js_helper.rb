module NumberToCurrencyJsHelper
  def number_to_currency_js(options={})
    options = I18n.translate(:"number.currency.format", locale: options[:locale], default: {})
    "<span style='display: none;' id='number-to-currency-data' data-options='#{options.to_json}'></span>".html_safe
  end
end
