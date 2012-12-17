action :before_compile do
end

action :before_deploy do
  template "#{node['nginx']['dir']}/sites-available/#{new_resource.application.name}.conf" do
    cookbook    "application_ruby"
    source      "nginx_frontend.conf.erb"
    owner       'root'
    group       'root'
    mode        '0644'
    variables({
      :socket => unicorn_resource.socket_location,
      :port => unicorn_resource.port,
      :public_path => "#{new_resource.application.path}/#{new_resource.static_files_path}"
    })

    if ::File.exists?("#{node['nginx']['dir']}/sites-enabled/#{new_resource.application.name}.conf")
      notifies :reload, 'service[nginx]', :immediately
    end
  end

  nginx_site "#{new_resource.application.name}.conf"
end

action :before_migrate do
end

action :before_symlink do
end

action :before_restart do
end

action :after_restart do
end

protected

def unicorn_resource
  new_resource.application.sub_resources.select { |res| res.type == :unicorn }.first
end
