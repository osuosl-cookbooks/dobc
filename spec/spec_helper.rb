require 'chefspec'
require 'chefspec/berkshelf'

ChefSpec::Coverage.start! { add_filter 'dobc' }

CENTOS_7 = {
  platform: 'centos',
  version: '7.4.1708',
}.freeze

RSpec.configure do |config|
  config.log_level = :fatal
end
