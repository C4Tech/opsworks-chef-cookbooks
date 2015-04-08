#
node[:deploy].each do |application, deploy|
    deploy[:brunch_variables].each do |key, value|
        Chef::Log.info("Setting ENV[#{key}] to #{value}")
        ENV[key] = value
    end

    execute "brunch_build" do
        command "brunch build -P"
        cwd "#{deploy[:deploy_to]}/current"
        only_if { File.exists?("#{deploy[:deploy_to]}/current/brunch-config.coffee") }
    end
end
