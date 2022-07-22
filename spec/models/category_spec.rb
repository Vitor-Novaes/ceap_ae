
describe Category, type: :model do
  subject { build(:category) }
  it { should have_many(:expenditures) }

  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name) }
end
