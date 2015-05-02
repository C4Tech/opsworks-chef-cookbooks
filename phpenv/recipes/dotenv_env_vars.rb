#  Custom Environment Variables are set as shown below:
#
# {
#      "deploy": {
#       "myapp": {
#       "application": "myapp",
#       "application_type": "php",
#       "environment": {
#         "database_endpoint": "mydbinstance.us-east-1.rds.amazonaws.com",
#      …
# }

node[:deploy].each do |application, deploy|
  template "#{deploy[:deploy_to]}/current/.env" do
    source "dotenv_variables.php.erb"
    owner deploy[:user]
    group deploy[:group]
    mode "0644"

    variables(
        :environment => (node[:deploy][application][:environment_variables] rescue nil),
        :application => "#{application}"
    )

    Chef::Log.info("Generating dotenv for app: #{application}...")

    only_if do
     deploy[:application_type] == "php" and File.directory?("#{deploy[:deploy_to]}/current/}")
    end
  end
end
