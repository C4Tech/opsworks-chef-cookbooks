#
node[:deploy].each do |application, deploy|
   execute "npm_update" do
        user deploy[:user]
        command "npm update --production"
        cwd "#{deploy[:deploy_to]}/current"
        only_if {::File.exists?('./package.json') }
   end
end
