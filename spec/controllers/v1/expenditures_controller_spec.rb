
describe V1::ExpendituresController, type: :controller do
  describe 'exposed routes' do
    it { should route(:get, '/v1/expenditures').to(action: :index) }
    it { should route(:get, '/v1/expenditures/:id').to(action: :show, id: 1) }
  end

  describe 'GET /v1/expenditures/:id' do
    let(:expenditure) { create(:expenditure) }

    context 'When is a valid id' do
      before { get :show, params: { id: expenditure.id } }

      it 'Should return the expenditure' do
        expect(response.body).to include_json(
          id: expenditure.id,
          provider: expenditure.provider,
          date: expenditure.date,
          period: expenditure.period,
          net_value: expenditure.net_value,
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

end
