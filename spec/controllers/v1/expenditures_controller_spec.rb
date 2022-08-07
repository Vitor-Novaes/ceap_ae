describe V1::ExpendituresController, type: :controller do
  describe 'exposed routes' do
    it { should route(:get, '/v1/expenditures').to(action: :index) }
    it { should route(:get, '/v1/expenditures/1').to(action: :show, id: 1) }
    it { should route(:post, '/v1/expenditures/import').to(action: :import_data) }
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

  describe 'POST /v1/expenditures/import' do
    context 'When pass nil file' do
      before { post :import_data, params: { file: nil } }

      include_examples 'bad_request response'

      it 'Should return error file' do
        expect(response.body).to include_json({
          errors: {
            message: "That action require CSV file type"
          }
        })
      end
    end

    context 'When pass file not allowed' do
      before { post :import_data, params: { file: Rack::Test::UploadedFile.new(file_fixture('Ano-2022.csv.zip')) } }

      include_examples 'bad_request response'

      it 'Should return error content-type' do
        expect(response.body).to include_json({
          errors: {
            message: "That action require CSV file type"
          }
        })
      end
    end
  end

  describe 'GET /v1/expenditures' do
    before do
      meshuggah = create(:organization, abbreviation: 'MSG')
      gojira = create(:organization, abbreviation: 'GJR')
      djent = create(:category, name: 'DJENT')
      metal = create(:category, name: 'METAL')

      torii = { name: 'Torii', organization: gojira, id: 99999 }

      create(:deputy, :with_expenditures, torii)
      create_list(:deputy, 2, :with_expenditures, organization: meshuggah)
      create_list(:deputy, 2, :with_expenditures, organization: gojira)
      create_list(:expenditure, 5, category: djent, date: '2020-07-30 00:00:00', provider: 'Wanner')
      create_list(:expenditure, 5, category: metal, date: '2022-08-02 00:00:00', provider: 'Wanner')
    end

    before(:each) { get :index, params: params }

    context 'When get all expenditures using all params deep filtering' do
      let(:params) {
        {
          sort_value: 'DESC',
          page: 1,
          per_page: 5,
          category: 'DJENT',
          provider: 'wanner',
          start_date: '2020-07-27 00:00:00',
          end_date: '2022-08-01 23:59:59'
        }
      }

      include_examples 'ok response'

      it 'Should return deep filter record' do
        expect(response.headers['X-Page']).to eq('1')
        expect(response.headers['X-Per-Page']).to eq('5')
        expect(response.headers['X-Total']).to eq('5')
        expect(response.headers['Link']).to be_nil
        expect(json_response[:expenditures].at(0)[:net_value] >
          json_response[:expenditures].at(1)[:net_value]
        )
      end
    end

    context 'When get all expenditures by organization order for higher net_value' do
      let(:params) {
        {
          total_spent: 'DESC',
          page: 1,
          per_page: 2,
          organization: 'GJR'
        }
      }

      include_examples 'ok response'

      it 'Should return match expenditures paginated' do
        expect(response.headers['X-Page']).to eq('1')
        expect(response.headers['X-Per-Page']).to eq('2')
        expect(response.headers['X-Total']).to eq('15')
        expect(response.headers['Link']).not_to be_nil
        expect(json_response[:expenditures].at(0)[:net_value] >
          json_response[:expenditures].at(1)[:net_value]
        )
      end
    end

    context 'When get all expenditures by deputy' do
      let(:params) {
        {
          total_spent: 'ASC',
          page: 1,
          per_page: 5,
          deputy: 99999,
        }
      }

      include_examples 'ok response'

      it 'Should return match expenditures paginated' do
        expect(response.headers['X-Page']).to eq('1')
        expect(response.headers['X-Per-Page']).to eq('5')
        expect(response.headers['X-Total']).to eq('5')
        expect(response.headers['Link']).to be_nil
        expect(json_response[:expenditures].at(0)[:net_value] <
          json_response[:expenditures].at(1)[:net_value]
        )
      end
    end

    context 'When get expenditures with unmatch params' do
      let(:params) {
        {
          total_spent: 'DESC',
          organization: 'MSG',
          category: 'METAL'
        }
      }

      include_examples 'ok response'

      it 'Should return no expenditures' do
        expect(response.headers['X-Page']).to eq('1')
        expect(response.headers['X-Per-Page']).to eq('10')
        expect(response.headers['X-Total']).to eq('0')
        expect(response.headers['Link']).to be_nil
      end
    end

    context 'When get expenditures with range date end only' do
      let(:params) {
        {
          provider: 'wanner',
          end_date: '2020-07-30 23:59:59'
        }
      }

      include_examples 'ok response'

      it 'Should return expenditures until that date' do
        expect(response.headers['X-Page']).to eq('1')
        expect(response.headers['X-Per-Page']).to eq('10')
        expect(response.headers['X-Total']).to eq('5')
        expect(response.headers['Link']).to be_nil
      end
    end

    context 'When get expenditures without params' do
      let(:params) { nil }

      include_examples 'ok response'

      it 'Should return all expenditures paginated' do
        expect(response.headers['X-Page']).to eq('1')
        expect(response.headers['X-Per-Page']).to eq('10')
        expect(response.headers['X-Total']).to eq('36')
        expect(response.headers['Link']).not_to be_nil
      end
    end
  end
end
