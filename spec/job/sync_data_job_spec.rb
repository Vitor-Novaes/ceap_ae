describe SyncDataJob, type: :job do
  include ActiveJob::TestHelper

  context '#perform_later' do
    it 'Should process data sync' do
      SyncDataJob.perform_later

      assert_enqueued_jobs 1, queue: 'default'
      expect(SyncDataJob).to be_retryable true
      expect(SyncDataJob).to be_processed_in :default
    end
  end
end
