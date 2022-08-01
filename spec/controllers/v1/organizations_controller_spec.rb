describe V1::OrganizationsController, type: :controller do
  describe 'exposed routes' do
    it { should route(:get, '/v1/organizations/1').to(action: :show, id: 1) }
    it { should route(:get, '/v1/organizations').to(action: :index) }
  end

  # at_least_for_now
  describe 'GET /v1/organizations/:id' do
    let(:organization) { create(:organization) }

    context 'When is a valid id' do
      before { get :show, params: { id: organization.id } }

      include_examples 'ok response'

      it 'Should return the organization' do
        expect(response.body).to include_json(
          id: organization.id,
          abbreviation: organization.abbreviation
        )
      end
    end

    context 'When is a invalid id' do
      before { get :show, params: { id: -1 } }

      include_examples 'not_found response'

      it 'Should return error not found message' do
        expect(json_response[:errors][:message]).to eq("Couldn't find Organization with 'id'=-1")
      end
    end
  end

  describe 'GET /v1/organizations' do
    before do
      create_list(:organization, 20)
    end

    before(:each) { get :index, params: params }

    context 'When get all organizations by paginate params' do
      let(:params) { { page: 3, per_page: 5 } }

      it 'Should return records paginated' do
        expect(response.headers['X-Page']).to eq('3')
        expect(response.headers['X-Per-Page']).to eq('5')
        expect(response.headers['X-Total']).to eq('23')
        expect(response.headers['Link']).not_to be_nil
      end
    end

    context 'When get all organizations without paginate params' do
      let(:params) { nil }

      it 'Should return records paginated' do
        expect(response.headers['X-Page']).to eq('1')
        expect(response.headers['X-Per-Page']).to eq('10')
        expect(response.headers['X-Total']).to eq('23')
        expect(response.headers['Link']).not_to be_nil
      end
    end
  end
end
