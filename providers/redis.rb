action :before_compile do
  new_resource.symlink_before_migrate.update({
    "redis.yml" => "config/redis.yml"
  })
end

action :before_deploy do
  redis_master = new_resource.find_matching_role(new_resource.role, true)
  Chef::Log.warn("No node with role #{new_resource.role}") if new_resource.role && !redis_master

  redis_ip = if redis_master.attribute?('cloud')
               if node.attribute?('cloud') && (redis_master['cloud']['provider'] == node['cloud']['provider'])
                 redis_master['cloud']['local_ipv4']
               else
                 redis_master['cloud']['public_ipv4']
               end
             else
               redis_master['ipaddress']
             end

  template "#{new_resource.application.path}/shared/redis.yml" do
    source "redis.yml.erb"
    cookbook "application_ruby"
    owner new_resource.owner
    group new_resource.group
    mode "644"
    variables.update(
      :env => new_resource.environment_name,
      :host => redis_ip,
      :port => new_resource.port
    )
  end
end

action :before_migrate do
end

action :before_symlink do
end

action :before_restart do
end

action :after_restart do
end
