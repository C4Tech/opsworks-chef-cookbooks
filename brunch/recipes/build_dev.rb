#
node[:deploy].each do |application, deploy|
   execute "brunch_build" do
        command "brunch build"
        cwd "#{deploy[:deploy_to]}/current"
        only_if { File.exists?("#{deploy[:deploy_to]}/current/brunch-config.coffee") }
   end
end
