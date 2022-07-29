
describe V1::DeputiesController, type: :controller do
  describe 'exposed routes' do
    it { should route(:get, '/v1/deputies/1').to(action: :show, id: 1) }
    it { should route(:get, '/v1/deputies').to(action: :index) }
  end

  describe 'GET /v1/deputies/:id' do
    let(:deputy) { create(:deputy, :with_expenditures) }

    context 'When is a valid id' do
      let(:response) { get :show, params: { id: deputy.id } }

      include_examples 'ok response'

      it 'Should return the deputy details' do
        expect(response.body).to include_json(
          id: deputy.id,
          name: deputy.name,
          cpf: deputy.cpf,
          state: deputy.state,
          photo_url: "http://www.camara.leg.br/internet/deputado/bandep/#{deputy.ide}.jpg",
          organization: {
            id: deputy.organization.id,
            abbreviation: deputy.organization.abbreviation
          },
          # total_expenditures: deputy.expenditures.sum(:net_value).ceil(2) TODO
          ide: deputy.ide,
          parlamentary_card: deputy.parlamentary_card
        )
      end
    end

    context 'When is a invalid id' do
      before { get :show, params: { id: -1 } }

      include_examples 'not_found response'

      it 'Should return error not found message' do
        expect(json_response[:errors][:message]).to eq("Couldn't find Deputy with 'id'=-1")
      end
    end
  end
end
