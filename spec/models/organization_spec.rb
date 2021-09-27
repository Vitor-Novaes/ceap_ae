
describe 'Given Organization Model', type: :model do
  context 'With invalid or missing data to organization' do
    it 'Then return error' do
      org = build(:organization, abbreviation: nil)
      expect(org.valid?).to be_falsey
      expect(org.errors.details).to have_key(:abbreviation)
    end
  end

  context 'With valid data to Organization' do
    it 'Then create a organization' do
      expect(build(:organization)).to be_valid
    end
  end
end
