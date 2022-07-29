Rails.application.config.to_prepare do
  $quotas_file_service = DataService::OpenDataQuotasFile.new()
  $open_data_service = DataService::OpenData.new()
end
