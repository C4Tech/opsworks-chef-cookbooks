#
node[:deploy].each do |application, deploy|
   execute "bower_install" do
        command "bower install --production --silent --allow-root"
        cwd "#{deploy[:deploy_to]}/current"
        only_if {::File.exists?("#{deploy[:deploy_to]}/current/bower.json") }
   end
end
