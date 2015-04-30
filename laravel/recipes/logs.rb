#
# Taken from:
# http://docs.aws.amazon.com/opsworks/latest/userguide/gettingstarted.walkthrough.photoapp.3.html
#
node[:deploy].each do |application, deploy|
bash "chmod_storage" do
    only_if { deploy[:application_type] == "php" }
    cwd "#{deploy[:deploy_to]}/current"
    code <<-EOH
    find ./storage -type d -exec chmod g+w {} \;
    chmod -R g+w storage
    EOH
  end
end
