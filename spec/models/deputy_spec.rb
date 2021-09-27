
describe 'Given Deputy Model', type: :model do
  context 'With invalid or missing data to Deputy' do
    it 'Then return error data' do
      deputy = build(:deputy, cpf: nil)
      expect(deputy.valid?).to be_falsey
      expect(deputy.errors.details).to have_key(:cpf)
    end

    it 'Then return error without organization' do
      expect(build(:deputy, organization: nil).valid?).to be_falsey
    end

    it 'Then return error couple unique data' do
      create(:deputy, cpf: '007007')
      deputy = build(:deputy, cpf: '007007')

      expect(deputy.valid?).to be_falsey
      expect(deputy.errors.details).to have_key(:cpf)
    end
  end

  context 'With valid data to deputy' do
    it 'Then create a deputy' do
      expect(build(:deputy)).to be_valid
    end
  end
end
