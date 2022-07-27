describe V1::OrganizationsController, type: :controller do
  describe 'exposed routes' do
    it { should route(:get, '/v1/organizations/1').to(action: :show, id: 1) }
    it { should route(:get, '/v1/organizations').to(action: :index) }
  end

  describe 'GET /v1/organizations/:id' do
    let(:organization) { create(:organization) }

    context 'When is a valid id' do
      before { get :show, params: { id: organization.id } }

      include_examples 'ok response'

      it 'Should return the organization' do
        expect(response.body).to include_json(
          id: organization.id,
          abbreviation: organization.abbreviation,
          deputies: [] #TODO feat
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
end
