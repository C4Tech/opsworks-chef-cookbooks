#
node[:deploy].each do |application, deploy|
   execute "bower_install" do
        user deploy[:user]
        command "bower install --production --silent"
        cwd "#{deploy[:deploy_to]}/current"
        only_if {::File.exists?("#{deploy[:deploy_to]}/current/bower.json") }
   end
end
