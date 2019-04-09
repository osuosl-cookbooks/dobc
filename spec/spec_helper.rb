require 'chefspec'
require 'chefspec/berkshelf'

ChefSpec::Coverage.start! { add_filter 'dobc' }

CENTOS_7 = {
  platform: 'centos',
  version: '7.4.1708',
  log_level: :fatal,
}.freeze

CENTOS_6 = {
  platform: 'centos',
  version: '6.9',
  log_level: :fatal,
}.freeze

RSpec.configure do |config|
  config.log_level = :fatal
end
