require 'serverspec'

set :backend, :exec

describe command('/usr/local/bin/start-all.sh /root/passwords.csv') do
  its(:exit_status) { should eq 0 }
end

%w(33000 33001).each do |p|
  describe port(p) do
    it { should be_listening }
  end
end

describe command('docker ps --format "{{.Names}}:{{.Status}}"') do
  its(:stdout) { should match(/^dobc-3300[01]:Up/) }
end

ssh_cmd = 'sshpass -p password ssh -p 33000 -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no ' \
          'dobc@localhost hostname'

describe command(ssh_cmd) do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(/^dobc$/) }
end

describe command('docker stop dobc-33000') do
  its(:exit_status) { should eq 0 }
end

describe command('/usr/local/bin/start-container.sh /root/passwords.csv 33000') do
  its(:exit_status) { should eq 0 }
end

describe command('docker ps --format "{{.Names}}:{{.Status}}"') do
  its(:stdout) { should match(/^dobc-3300[01]:Up/) }
end

describe command('/usr/local/bin/stop-all.sh /root/passwords.csv') do
  its(:exit_status) { should eq 0 }
end

describe command('docker ps --format "{{.Names}}:{{.Status}}"') do
  its(:stdout) { should_not match(/^dobc-3300[01]:Up/) }
end
