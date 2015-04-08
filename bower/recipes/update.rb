#
# Taken from:
# http://docs.aws.amazon.com/opsworks/latest/userguide/gettingstarted.walkthrough.photoapp.3.html
#
node[:deploy].each do |application, deploy|
   execute "bower_update" do
        user deploy[:user]
        command "bower update --production --silent"
        cwd "#{deploy[:deploy_to]}/current"
        only_if {::File.exists?("#{deploy[:deploy_to]}/current/bower.json") }
   end
end
