node[:deploy].each do |app_name, deploy_config|
  # determine root folder of new app deployment
  app_root = "#{deploy_config[:deploy_to]}/current"

  # use template 'secrets.yml.erb' to generate 'config/secrets.yml'
  template "#{app_root}/config/secrets.yml" do
    source "secrets.yml.erb"
    cookbook "rails"

    # set mode, group and owner of generated file
    mode "0660"
    group deploy_config[:group]
    owner deploy_config[:user]

    # define variable “@secrets to be used in the ERB template
    variables(
      :secrets => deploy_config[:secrets] || {}
    )

    # only generate a file if there is Redis configuration
    not_if do
      deploy_config[:secrets].blank?
    end
  end
end
