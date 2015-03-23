#
# Run Bower installation if there's a bower.json
#

node[:deploy].each do |application, deploy|
  execute "/usr/local/bin/bower install --production" do
    only_if { File.exists?("#{deploy[:deploy_to]}/current/bower.json") }
    cwd "#{deploy[:deploy_to]}/current"
  end
end
