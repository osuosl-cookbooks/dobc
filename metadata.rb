name             'dobc'
maintainer       'Oregon State University'
maintainer_email 'chef@osuosl.org'
license          'Apache-2.0'
chef_version     '>= 16.0'
issues_url       'https://github.com/osuosl-cookbooks/dobc/issues'
source_url       'https://github.com/osuosl-cookbooks/dobc'
description      'Installs/Configures dobc'
version          '2.2.0'

depends          'base'
depends          'firewall'
depends          'osl-docker'

supports         'centos', '~> 7.0'
