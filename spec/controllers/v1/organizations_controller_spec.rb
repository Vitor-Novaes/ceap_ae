
require 'rails_helper'

describe V1::OrganizationsController, type: :controller do
  context 'routes' do
    it { should route(:get, '/v1/organizations/1').to(action: :show, id: 1) }
    it { should route(:get, '/v1/organizations').to(action: :index) }
  end

  describe 'GET /v1/organizations/:id' do
    let(:organization) { create(:organization) }

    context 'When is a valid id' do
      let(:response) { get :show, params: { id: organization.id } }

      include_examples 'ok request'

      it 'should return the organization' do
        expect(json_response[:abbreviation]).not_to be_nil
        expect(json_response[:deputies]).not_to be_nil
      end
    end

    context 'When is a invalid id' do
      let(:response) { get :show, params: { id: -1 } }

      include_examples 'not found'
    end
  end
end
