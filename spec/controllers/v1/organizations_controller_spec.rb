describe V1::OrganizationsController, type: :controller do
  describe 'exposed routes' do
    it { should route(:get, '/v1/organizations').to(action: :index) }
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
