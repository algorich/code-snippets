module NumberToCurrencyJsHelper
  def number_to_currency_js(options={})
    options = ActiveSupport::NumberHelper.send(:i18n_format_options, options[:locale], :currency)
    "<span style='display: none;' id='number-to-currency-data' data-options='#{options.to_json}'></span>".html_safe
  end
end