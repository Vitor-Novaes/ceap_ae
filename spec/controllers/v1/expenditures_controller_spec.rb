describe V1::ExpendituresController, type: :controller do
  include ActiveJob::TestHelper
  describe 'exposed routes' do
    it { should route(:get, '/v1/expenditures').to(action: :index) }
    it { should route(:get, '/v1/expenditures/1').to(action: :show, id: 1) }
    it { should route(:get, 'v1/expenditures/import-stream-data').to(action: :import_stream_data) }
  end

  describe 'GET /v1/expenditures/:id' do
    let(:expenditure) { create(:expenditure) }

    context 'When is a valid id' do
      before { get :show, params: { id: expenditure.id } }

      include_examples 'ok response'

      it 'Should return the expenditure' do
        expect(response.body).to include_json(
          id: expenditure.id,
          provider: expenditure.provider,
          date: expenditure.date.to_s,
          period: expenditure.period,
          # net_value: expenditure.total_expense,
          category: {
            id: expenditure.category.id,
            name: expenditure.category.name
          },
          deputy: {
            id: expenditure.deputy.id,
            cpf: expenditure.deputy.cpf,
            name: expenditure.deputy.name,
            state: expenditure.deputy.state,
            organization: {
              id: expenditure.deputy.organization.id,
              abbreviation: expenditure.deputy.organization.abbreviation
            }
          }
        )
      end
    end

    context 'When is a invalid id' do
      before { get :show, params: { id: -1 } }

      include_examples 'not_found response'

      it 'Should return error not found message' do
        expect(json_response[:errors][:message]).to eq("Couldn't find Expenditure with 'id'=-1")
      end
    end
  end

  describe 'GET /v1/import-stream-data' do
    context 'When start job sync data' do
      before { get :import_stream_data }

      include_examples 'ok response'

      it 'Should enqueue it' do
        assert_enqueued_jobs 1, queue: 'default'
        expect(SyncDataJob).to be_processed_in :default
        expect(SyncDataJob).to be_retryable true
        expect(json_response[:message]).to eq('successfully enqueue sync data')
      end
    end
  end
end
