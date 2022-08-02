
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

  describe 'GET /v1/deputies' do
    before do
      meshuggah = create(:organization, abbreviation: 'MSG')
      gojira = create(:organization, abbreviation: 'GJR')
      sepultura = create(:organization, abbreviation: 'SPL')

      itsari = {
        name: 'Itsári', organization: sepultura,
        ide: '2000', parlamentary_card: '2000', cpf: '40028922'
      }

      create_list(:deputy, 4, :with_expenditures, name: 'José')
      create_list(:deputy, 5, :with_expenditures, organization: meshuggah)
      create_list(:deputy, 5, :with_expenditures, organization: gojira)
      create_list(:deputy, 5, :with_expenditures, organization: sepultura)
      create(:deputy, :with_expenditures, itsari)
    end

    before(:each) { get :index, params: params }

    context 'When get all deputies using all params deep filtering' do
      let(:params) {
        {
          total_spent: 'DESC',
          page: 1,
          per_page: 5,
          name: 'Its',
          organization: 'SPL',
          ide: '20',
          parlamentary_card: '20',
          cpf: '4002'
        }
      }

      include_examples 'ok response'

      it 'Should return deep filter record' do
        expect(response.headers['X-Page']).to eq('1')
        expect(response.headers['X-Per-Page']).to eq('5')
        expect(response.headers['X-Total']).to eq('1')
        expect(response.body).to include_json({
          0 => { name: 'Itsári', organization: { abbreviation: 'SPL'},
          ide: '2000', parlamentary_card: '2000', cpf: '40028922' }
        })
      end
    end

    context 'When get all deputies order for DESC total spent by organization' do
      let(:params) {
        {
          total_spent: 'DESC',
          page: 1,
          per_page: 2,
          organization: 'GJR'
        }
      }

      include_examples 'ok response'

      it 'Should return match deputies paginated' do
        expect(response.headers['X-Page']).to eq('1')
        expect(response.headers['X-Per-Page']).to eq('2')
        expect(response.headers['X-Total']).to eq('5')
        expect(response.headers['Link']).not_to be_nil
        expect(json_response.at(0)[:total_spent] > json_response.at(1)[:total_spent])
      end
    end

    context 'When get all deputies by search term attribute' do
      let(:params) {
        {
          total_spent: 'DESC',
          page: 1,
          per_page: 4,
          name: 'josé'
        }
      }

      include_examples 'ok response'

      it 'Should return match deputies paginated' do
        expect(response.headers['X-Page']).to eq('1')
        expect(response.headers['X-Per-Page']).to eq('4')
        expect(response.headers['X-Total']).to eq('4')
        expect(response.headers['Link']).to be_nil
      end
    end

    context 'When get deputies with unmatch params' do
      let(:params) {
        {
          total_spent: 'DESC',
          page: 1,
          per_page: 4,
          name: 'Itsári',
          organization: 'MSG',
        }
      }

      include_examples 'ok response'

      it 'Should return no deputies' do
        expect(response.headers['X-Page']).to eq('1')
        expect(response.headers['X-Per-Page']).to eq('4')
        expect(response.headers['X-Total']).to eq('0')
        expect(response.headers['Link']).to be_nil
      end
    end

    context 'When get deputies without params' do
      let(:params) { nil }

      include_examples 'ok response'

      it 'Should return all deputies paginated' do
        expect(response.headers['X-Page']).to eq('1')
        expect(response.headers['X-Per-Page']).to eq('10')
        expect(response.headers['X-Total']).to eq('22')
        expect(response.headers['Link']).not_to be_nil
      end
    end
  end
end
