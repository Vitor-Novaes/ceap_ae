
describe Expenditure, type: :model do
  it { should belong_to(:category) }
  it { should belong_to(:deputy) }

  it { should validate_presence_of(:receipt_type) }
  it { should validate_presence_of(:period) }
end
