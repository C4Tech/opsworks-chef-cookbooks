#
node[:deploy].each do |application, deploy|
   execute "bower_install" do
        user deploy[:user]
        command "bower install --production"
        cwd "#{deploy[:deploy_to]}/current"
        only_if {::File.exists?('./bower.json') }
   end
end
