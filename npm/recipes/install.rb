#
node[:deploy].each do |application, deploy|
   execute "npm_install" do
        command "npm install --production"
        cwd "#{deploy[:deploy_to]}/current"
        only_if {::File.exists?("#{deploy[:deploy_to]}/current/package.json") }
   end
end