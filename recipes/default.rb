#
# Cookbook:: dobc
# Recipe:: default
#
# Copyright:: 2017-2023, Oregon State University
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

include_recipe 'osl-docker'

osl_firewall_docker 'docker firewall' do
  allowed_ipv4 %w(0.0.0.0)
  expose_ports true
end

%w(
  start-all.sh
  start-container.sh
  start-mysql.sh
  stop-all.sh
).each do |file|
  cookbook_file ::File.join('/usr/local/bin', file) do
    mode '0755'
  end
end
