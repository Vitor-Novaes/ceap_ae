
require 'rails_helper'

describe V1::DeputiesController, type: :controller do
  context 'routes' do
    it { should route(:get, '/v1/deputies/1').to(action: :show, id: 1) }
    it { should route(:get, '/v1/deputies').to(action: :index) }
  end

  describe 'GET /v1/deputies/:id' do
    let(:deputy) { create(:deputy, :with_expenditures) }

    context 'When is a valid id' do
      let(:response) { get :show, params: { id: deputy.id } }

      include_examples 'ok request'

      it 'should return the deputy' do
        expect(json_response[:expensive_expense]).not_to be_nil
        expect(json_response[:parlamentary_card]).not_to be_nil
        expect(json_response[:total_expense]).not_to be_nil
        expect(json_response[:expenditures]).not_to be_nil
        expect(json_response[:photo_url]).not_to be_nil
        expect(json_response[:state]).not_to be_nil
        expect(json_response[:cpf]).not_to be_nil
        expect(json_response[:ide]).not_to be_nil
      end
    end

    context 'When is a invalid id' do
      let(:response) { get :show, params: { id: -1 } }

      include_examples 'not found'
    end
  end
end
