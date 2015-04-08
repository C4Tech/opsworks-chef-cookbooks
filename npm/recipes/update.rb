#
node[:deploy].each do |application, deploy|
   execute "npm_update" do
        command "npm update --production"
        cwd "#{deploy[:deploy_to]}/current"
        only_if {::File.exists?("#{deploy[:deploy_to]}/current/package.json") }
   end
end
