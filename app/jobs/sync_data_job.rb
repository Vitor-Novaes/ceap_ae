class SyncDataJob < ApplicationJob
  queue_as :default

  def perform(*args)
    file = $quotas_file_service.download_by_year(Time.now.year)
    Populate::QuotasFileSource.new(file).execute
  end
end
