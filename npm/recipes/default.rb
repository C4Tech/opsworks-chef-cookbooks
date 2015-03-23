include_recipe 'deploy'

node[:deploy].each do |application, deploy|
  execute "/usr/local/bin/npm install --production" do
    cwd "#{deploy[:deploy_to]}/current"
  end
end
