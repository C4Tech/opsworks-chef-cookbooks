#
# Run NPM installation if there's a package.json
#

node[:deploy].each do |application, deploy|
  if File.exists?("#{deploy[:deploy_to]}/current/package.json")
    node[:deploy].each do |application, deploy|
      execute "/usr/local/bin/npm install --production" do
        cwd "#{deploy[:deploy_to]}/current"
      end
    end
  end
end
