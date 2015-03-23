#
# Run Brunch build if there's a brunch-config.coffee
#

node[:deploy].each do |application, deploy|
  execute "/usr/local/bin/brunch build" do
    only_if { File.exists?("#{deploy[:deploy_to]}/current/brunch-config.coffee") }
    user deploy[:user]
    cwd "#{deploy[:deploy_to]}/current"
  end
end
