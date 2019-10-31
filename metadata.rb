name             'dobc'
maintainer       'Oregon State University'
maintainer_email 'chef@osuosl.org'
license          'Apache-2.0'
chef_version     '>= 12.18' if respond_to?(:chef_version)
issues_url       'https://github.com/osuosl-cookbooks/dobc/issues'
source_url       'https://github.com/osuosl-cookbooks/dobc'
description      'Installs/Configures dobc'
long_description 'Installs/Configures dobc'
version          '2.0.2'

depends          'firewall'
depends          'osl-docker'

supports         'centos', '~> 7.0'
