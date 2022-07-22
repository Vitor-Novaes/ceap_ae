
describe Organization, type: :model do
  it { should have_many(:deputies) }

  it { should validate_presence_of(:abbreviation) }
end
