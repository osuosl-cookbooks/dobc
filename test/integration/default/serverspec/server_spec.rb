require 'serverspec'

set :backend, :exec

describe command('/usr/local/bin/start-all.sh /root/passwords.csv') do
  its(:exit_status) { should eq 0 }
end

%w(33000 33001 34000 34001).each do |p|
  describe port(p) do
    it { should be_listening }
  end
end

describe command('docker ps --format "{{.Names}}:{{.Status}}"') do
  its(:stdout) { should match(/^dobc-0[01]:Up/) }
end

ssh_cmd = 'sshpass -p password ssh -p 33000 -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no ' \
          'dobc@localhost'

describe command("#{ssh_cmd} hostname") do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(/^dobc$/) }
end

describe command("#{ssh_cmd} \"sleep 5 ; mysql -h'172.17.0.2' -P'3306' -uroot -p'dobc' -e exit\"") do
  its(:exit_status) { should eq 0 }
end

%w(dobc mysql).each do |c|
  describe command("docker stop #{c}-00") do
    its(:exit_status) { should eq 0 }
  end
end

describe command('/usr/local/bin/start-container.sh /root/passwords.csv 00') do
  its(:exit_status) { should eq 0 }
end

describe command('/usr/local/bin/start-mysql.sh /root/passwords.csv 00') do
  its(:exit_status) { should eq 0 }
end

describe command('docker ps --format "{{.Names}}:{{.Status}}"') do
  its(:stdout) { should match(/^dobc-0[01]:Up/) }
  its(:stdout) { should match(/^mysql-0[01]:Up/) }
end

describe command('/usr/local/bin/stop-all.sh /root/passwords.csv') do
  its(:exit_status) { should eq 0 }
end

describe command('docker ps --format "{{.Names}}:{{.Status}}"') do
  its(:stdout) { should_not match(/^dobc-0[01]:Up/) }
  its(:stdout) { should_not match(/^mysql-0[01]:Up/) }
end
