script_path = '/usr/local/bin'
pass_csv_path = '/root/passwords.csv'

%w(
  start-all.sh
  start-container.sh
  start-mysql.sh
  stop-all.sh
).each do |file|
  script = ::File.join(script_path, file)
  describe file(script) do
    it { should exist }
    its('mode') { should cmp '0755' }
  end
end

script = ::File.join(script_path, 'start-all.sh')
describe command("#{script} #{pass_csv_path}") do
  its(:exit_status) { should eq 0 }
end

%w(33000 33001 34000 34001).each do |p|
  describe port(p) do
    it { should be_listening }
  end
end

describe command('docker ps --format "{{.Names}}:{{.Status}}"') do
  its(:stdout) { should match(/^dobc-0[01]:Up/) }
  its(:stdout) { should match(/^mysql-0[01]:Up/) }
end

script = 'sshpass -p password ssh -p 33000 -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no ' \
      'dobc@localhost'
describe command("#{script} hostname") do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(/^dobc$/) }
end
describe command("#{script} \"sleep 5 ; mysql -h'172.17.0.2' -P'3306' -uroot -p'dobc' -e exit\"") do
  its(:exit_status) { should eq 0 }
end

%w( dobc mysql ).each do |cmd|
  describe command("docker stop #{cmd}-00") do
    its(:exit_status) { should eq 0 }
  end
end

%w( start-container.sh start-mysql.sh ).each do |file|
  script = ::File.join(script_path, file)
  describe command("#{script} #{pass_csv_path} 00") do
    its(:exit_status) { should eq 0 }
  end
end

describe command('docker ps --format "{{.Names}}:{{.Status}}"') do
  its(:stdout) { should match(/^dobc-0[01]:Up/) }
  its(:stdout) { should match(/^mysql-0[01]:Up/) }
end

script = ::File.join(script_path, 'stop-all.sh')
describe command("#{script} #{pass_csv_path}") do
  its(:exit_status) { should eq 0 }
end

describe command('docker ps --format "{{.Names}}:{{.Status}}"') do
  its(:stdout) { should_not match(/^dobc-0[01]:Up/) }
  its(:stdout) { should_not match(/^mysql-0[01]:Up/) }
end
