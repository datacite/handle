default['java']['install_flavor'] = "oracle"
default['java']['oracle']['accept_oracle_download_terms'] = true
default['java']['jdk_version'] = "8"

default['handle']['dir'] = "/hs"
default['handle']['version'] = "8.1.1"

# configuration for all servers
default['handle']['bind_address'] = "0.0.0.0"
default['handle']['sql_host'] = ""
default['handle']['log_accesses'] = "yes"
default['handle']['log_save_interval'] = "Monthly"

# configuration for each server
default['handle']['servers'] = [
  { 'name' => 'svr_1',
    'this_server_id' => 1,
    'port' => '2641',
    'http_port' => '8000',
    'log_save_directory' => 'logs',
    'sql_db' => '',
    'sql_login' => '',
    'sql_passwd' => '',
    'server_admins' => '',
    'replication_authentication' => '',
    'replication_sites_handle' => '' }
]
