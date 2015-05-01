#  Custom Environment Variables are set as shown below:
#
#
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
    mode "0666"

    variables(
        :env => (node[:custom_env] rescue nil),
        :environment => (node[:custom_env][application.to_s][:environment] rescue nil),
        :application => "#{application}"
    )

    Chef::Log.info("Generating dotenv for app: #{application} with env: #{node[:custom_env][application.to_s][:environment]}...")


    only_if do
     File.directory?("#{deploy[:deploy_to]}/current/}")
    end
  end
end
