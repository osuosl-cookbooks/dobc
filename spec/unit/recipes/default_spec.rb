require_relative '../../spec_helper'

describe 'dobc::default' do
  cached(:chef_run) do
    ChefSpec::SoloRunner.new(CENTOS_7).converge(described_recipe)
  end
  it 'converges successfully' do
    expect { chef_run }.to_not raise_error
  end

  it { expect(chef_run).to include_recipe('osl-docker') }

  %w(
    start-all.sh
    start-container.sh
    start-mysql.sh
    stop-all.sh
  ).each do |file|
    it do
      expect(chef_run).to create_cookbook_file(::File.join('/usr/local/bin', file)).with(mode: '0755')
    end
  end

  it do
    expect(chef_run).to accept_osl_firewall_docker('docker firewall').with(
      allowed_ipv4: %w(0.0.0.0),
      expose_ports: true
    )
  end

  context 'almalinux 8' do
    cached(:chef_run) do
      ChefSpec::SoloRunner.new(ALMA_8).converge(described_recipe)
    end
    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end
  end
end
