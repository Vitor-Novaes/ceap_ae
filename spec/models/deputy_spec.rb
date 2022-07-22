
describe Deputy, type: :model do
  subject { build(:deputy) }
  it { should belong_to(:organization) }
  it { should have_many(:expenditures) }

  it { should validate_presence_of(:cpf) }
  it { should validate_presence_of(:ide) }
  it { should validate_presence_of(:parlamentary_card) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:state) }

  it { should validate_uniqueness_of(:cpf).case_insensitive }
  it { should validate_uniqueness_of(:ide).case_insensitive }
  it { should validate_uniqueness_of(:parlamentary_card).case_insensitive }
end
