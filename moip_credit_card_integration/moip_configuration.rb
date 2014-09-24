MyMoip.environment = Rails.env.production? ? 'production' : 'sandbox'
MyMoip.logger = Rails.logger

MyMoip.default_referer_url = 'http://' + yourApplicationName::Application.config.action_mailer.default_url_options[:host]

MyMoip.sandbox_token    = ''
MyMoip.sandbox_key      = ''

MyMoip.production_token = ''
MyMoip.production_key   = ''