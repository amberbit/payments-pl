$LOAD_PATH.unshift 'lib'
require 'payments_pl/silencer'

PaymentsPl::Silencer.silently {
  require 'bundler/setup'
  Bundler.require(:development)
}

require 'payments_pl'

require 'pp'
