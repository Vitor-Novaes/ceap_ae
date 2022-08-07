describe ImportDataJob, type: :job do
  include ActiveJob::TestHelper

  context '#perform_later' do
    it 'Should process data import file' do
      ImportDataJob.perform_later('tmp/some_file')

      assert_enqueued_jobs 1, queue: 'default'
      expect(ImportDataJob).to be_retryable true
      expect(ImportDataJob).to be_processed_in :default
    end
  end
end
