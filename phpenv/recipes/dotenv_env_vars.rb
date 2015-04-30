#  Custom Environment Variables May be set as shown below:
# 
# 
# 
# {
#     "custom_env": {
#         "staging_site": {
#             "environment": "staging",
#             "path_to_vars": "src/acme/application/config/staging",
#             "env_vars" : [ 
#                 "CACHE_TIME=3600", 
#                 "SOME_API_KEY=BlahBlah", 
#                 "ANOTHER_API_KEY=helloWorld!" 
#             ] 
#         },
#         "production_site": {
#             "htaccess_template": "advanced_htaccess.rb",
#             "path_to_vars": "src/acme/application/config/production",
#             "env_vars" : [ 
#                 "CACHE_TIME=1234", 
#                 "SOME_API_KEY=nahnah", 
#                 "ANOTHER_API_KEY=hello-monkey!" 
#             ] 
#         }
#     }
# }




node[:deploy].each do |application, deploy|
  
  template "#{deploy[:deploy_to]}/shared/.env" do
    source "dotenv_variables.php.erb"
    owner deploy[:user] 
    group deploy[:group]
    mode "0666"

    variables( 
        :env => (node[:custom_env] rescue nil), 
        :environment => (node[:custom_env][application.to_s][:environment] rescue nil),
        :application => "#{application}" 
    )

    Chef::Log.info("Generating dotenv for app: #{application} with env: #{custom_env}...")
   
    
    only_if do
     File.directory?("#{deploy[:deploy_to]}/shared/}")
    end
  end
end
