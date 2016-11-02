include_recipe 'java'

# root directory for handle server
directory node['handle']['dir'] do
  owner 'root'
  group 'root'
  mode '0755'
  recursive true
  action :create
end

# download source code
tarball = "hsj-#{node['handle']['version']}.tar.gz"
download_url = "http://www.handle.net/hnr-source/#{tarball}"

remote_file "#{node['handle']['dir']}/#{tarball}" do
  source download_url
  action :create_if_missing
  mode '0644'
end

# uncompress
execute "tar" do
  user "root"
  group "root"
  cwd node['handle']['dir']
  action :run
  command "tar xvzf #{tarball}"
  not_if{ ::File.directory?("#{node['handle']['dir']}/hsj-#{node['handle']['version']}") }
end

# configure one or more handle servers
node['handle']['servers'].each do |server|
  # install directory for handle server
  directory "#{node['handle']['dir']}/#{server['name']}" do
    owner 'root'
    group 'root'
    mode '0755'
    action :create
  end

  # handle server configuration
  template 'config.dct' do
    path   "#{node['handle']['dir']}/#{server['name']}/config.dct"
    source 'config.dct.erb'
    owner  'root'
    group  'root'
    mode   '0644'
    cookbook 'handle'
    variables(
      this_server_id: server['this_server_id'],
      port: server['port'],
      http_port: server['http_port'],
      log_save_directory: server['log_save_directory'],
      sql_db: server['sql_db'],
      sql_login: server['sql_login'],
      sql_passwd: server['sql_passwd'],
      server_admins: server['server_admins'],
      replication_authentication: server['replication_authentication'],
      replication_sites_handle: server['replication_sites_handle'],
    )
  end

  execute "install" do
    user "root"
    group "root"
    cwd "#{node['handle']['dir']}/hsj-#{node['handle']['version']}"
    action :run
    command "bin/hdl-setup-server #{node['handle']['dir']}/#{server['name']}"
  end
end
