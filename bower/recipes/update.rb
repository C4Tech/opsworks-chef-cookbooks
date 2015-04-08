#
# Taken from:
# http://docs.aws.amazon.com/opsworks/latest/userguide/gettingstarted.walkthrough.photoapp.3.html
#
node[:deploy].each do |application, deploy|
   execute "bower_update" do
        user deploy[:user]
        command "bower update --production"
        cwd "#{deploy[:deploy_to]}/current"
        only_if {::File.exists?('./bower.json') }
   end
end
