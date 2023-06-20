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

%w( dobc-00 dobc-01 mysql-00 mysql-01 ).each do |cont|
  describe docker_container(name: cont) do
    it { should exist }
    it { should be_running }
    its('id') { should_not eq '' }
    case cont
    when 'dobc-00'
      its('ports') { should eq '0.0.0.0:33000->22/tcp, :::33000->22/tcp,0.0.0.0:34000->8080/tcp, :::34000->8080/tcp' }
    when 'dobc-01'
      its('ports') { should eq '0.0.0.0:33001->22/tcp, :::33001->22/tcp, 0.0.0.0:34001->8080/tcp, :::34001->8080/tcp' }
    when 'mysql-00'
      its('ports') { should eq '3306/tcp' }
    when 'mysql-01'
      its('ports') { should eq '3306/tcp' }
    end
  end
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
  describe docker_container(name: "#{cmd}-00") do
    it { should_not exist }
    it { should_not be_running }
  end
end

%w( start-container.sh start-mysql.sh ).each do |file|
  script = ::File.join(script_path, file)
  describe command("#{script} #{pass_csv_path} 00") do
    its(:exit_status) { should eq 0 }
  end
end

%w( dobc-00 dobc-01 mysql-00 mysql-01 ).each do |cont|
  describe docker_container(name: cont) do
    it { should exist }
    it { should be_running }
  end
end

script = ::File.join(script_path, 'stop-all.sh')
describe command("#{script} #{pass_csv_path}") do
  its(:exit_status) { should eq 0 }
end

%w( dobc-00 dobc-01 mysql-00 mysql-01 ).each do |cont|
  describe docker_container(name: cont) do
    it { should_not exist }
    it { should_not be_running }
  end
end
