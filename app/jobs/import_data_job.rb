class ImportDataJob < ApplicationJob
  queue_as :default

  # at_least_for_now to_remove
  def perform(file_path)
    temp_file = File.open(file_path, 'r')
    begin
      Populate::QuotasFileSource.new(temp_file).execute
    ensure
      temp_file.close
      File.delete(file_path)
    end
  end
end
