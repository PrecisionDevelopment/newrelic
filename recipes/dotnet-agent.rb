#
# Cookbook Name:: newrelic
# Recipe:: dotnet-agent
#
# Copyright 2012-2014, Escape Studios
#

include_recipe 'newrelic::repository'
include_recipe node['newrelic']['dotnet-agent']['dotnet_recipe']

license = node['newrelic']['application_monitoring']['license']

windows_package 'Install New Relic .NET Agent' do
  source node['newrelic']['dotnet-agent']['https_download']
  options "/qb NR_LICENSE_KEY=#{license} INSTALLLEVEL=#{node['newrelic']['dotnet-agent']['install_level']}"
  installer_type :msi
  action :install
  not_if { File.exist?('C:\\Program Files\\New Relic\\.NET Agent') }
end

template node['newrelic']['dotnet-agent']['config_file'] do
  source 'newrelic.config.erb'
  variables(
    :license => license,
    :appname => node['newrelic']['application_monitoring']['appname'],
    :enabled => node['newrelic']['application_monitoring']['enabled'],
    :logfile => node['newrelic']['application_monitoring']['logfile'],
    :loglevel => node['newrelic']['application_monitoring']['loglevel'],
    :daemon_ssl => node['newrelic']['application_monitoring']['daemon']['ssl'],
    :capture_params => node['newrelic']['application_monitoring']['capture_params'],
    :ignored_params => node['newrelic']['application_monitoring']['ignored_params'],
    :transaction_tracer_enable => node['newrelic']['application_monitoring']['transaction_tracer']['enable'],
    :transaction_tracer_threshold => node['newrelic']['application_monitoring']['transaction_tracer']['threshold'],
    :transaction_tracer_record_sql => node['newrelic']['application_monitoring']['transaction_tracer']['record_sql'],
    :transaction_tracer_stack_trace_threshold => node['newrelic']['application_monitoring']['transaction_tracer']['stack_trace_threshold'],
    :transaction_tracer_slow_sql => node['newrelic']['application_monitoring']['transaction_tracer']['slow_sql'],
    :transaction_tracer_explain_threshold => node['newrelic']['application_monitoring']['transaction_tracer']['explain_threshold'],
    :error_collector_enable => node['newrelic']['application_monitoring']['error_collector']['enable'],
    :browser_monitoring_auto_instrument => node['newrelic']['application_monitoring']['browser_monitoring']['auto_instrument'],
    :cross_application_tracer_enable => node['newrelic']['application_monitoring']['cross_application_tracer']['enable']
  )
  action :create
end
