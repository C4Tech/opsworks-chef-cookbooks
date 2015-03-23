#
# Run NPM installation if there's a package.json
#

node[:deploy].each do |application, deploy|
  execute "/usr/local/bin/npm install --production" do
    only_if { File.exists?("#{deploy[:deploy_to]}/current/package.json") }
    cwd "#{deploy[:deploy_to]}/current"
  end
end
