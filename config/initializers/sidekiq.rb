Sidekiq.configure_server do |config|
  config.redis = { url: ENV.fetch('REDIS_URL') }

  # If want load others schedules
  # config.on(:startup) do
  #   schedule_file = "config/users_schedule.yml"

  #   if File.exist?(schedule_file)
  #     Sidekiq::Cron::Job.load_from_hash YAML.load_file(schedule_file)
  #   end
  # end
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV.fetch('REDIS_URL') }
end
