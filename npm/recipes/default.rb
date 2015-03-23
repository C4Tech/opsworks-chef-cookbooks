include_recipe 'deploy'

if File.exists?("#{deploy[:deploy_to]}/current/package.json")
  node[:deploy].each do |application, deploy|
    execute "/usr/local/bin/npm install --production" do
      cwd "#{deploy[:deploy_to]}/current"
    end
  end
end
