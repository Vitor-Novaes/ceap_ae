describe V1::CategoriesController, type: :controller do
  describe 'exposed routes' do
    it { should route(:get, '/v1/categories').to(action: :index) }
  end

  describe 'GET /v1/categories' do
    before do
      create_list(:category, 20, :with_expenditure)
      create(:category, :with_expenditure, name: 'bad romance')
    end

    before(:each) { get :index, params: params }

    context 'When get all categories using all params deep filtering' do
      let(:params) { { page: 1, per_page: 5, total_spent: 'ASC', name: 'bad' } }

      it 'Should return records paginated' do
        expect(response.headers['X-Page']).to eq('1')
        expect(response.headers['X-Per-Page']).to eq('5')
        expect(response.headers['X-Total']).to eq('1')
        expect(response.headers['Link']).to be_nil
        expect(response.body).to include_json({
          categories: { 0 => { name: 'bad romance' } }
        })
      end
    end

    context 'When get all categories without paginate params' do
      let(:params) { { total_spent: 'DESC' } }

      it 'Should return records paginated' do
        expect(response.headers['X-Page']).to eq('1')
        expect(response.headers['X-Per-Page']).to eq('10')
        expect(response.headers['X-Total']).to eq('22')
        expect(response.headers['Link']).not_to be_nil
        expect(json_response[:categories].first[:total_spent] >
          json_response[:categories].last[:total_spent]
        )
      end
    end
  end
end
