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
  
  template "#{deploy[:deploy_to]}/shared/.env" do
    source "dotenv_variables.php.erb"
    owner deploy[:user] 
    group deploy[:group]
    mode "0666"

    variables( 
        :application => "#{application}" 
    )

    Chef::Log.info("Generating dotenv for app: #{application}...")
   
    
    only_if do
     File.directory?("#{deploy[:deploy_to]}/shared/}")
    end
  end
end
