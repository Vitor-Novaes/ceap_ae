
describe 'Given Expenditure Model', type: :model do
  context 'With invalid or missing data to Expenditure' do
    it 'When receipt type not allowed' do
      exp = build(:expenditure, receipt_type: 'NOT ALLOWED')
      expect(exp.valid?).to be_falsey
      expect(exp.errors.details).to have_key(:receipt_type)
      expect(exp.errors.details[:receipt_type][0][:error]).to equal(:inclusion)
    end

    it 'When deputy is nil' do
      exp = build(:expenditure, deputy: nil)
      expect(exp.valid?).to be_falsey
      expect(exp.errors.details).to have_key(:deputy)
    end

    it 'When missing data required' do
      exp = build(:expenditure, period: nil)
      expect(exp.valid?).to be_falsey
      expect(exp.errors.details).to have_key(:period)
    end
  end

  context 'With valid data to Expenditure' do
    it 'Then create a Expenditure' do
      expect(build(:expenditure)).to be_valid
    end
  end
end
