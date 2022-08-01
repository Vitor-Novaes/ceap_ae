describe Populate::QuotasFileSource do
  describe '#execute' do
    context 'When given correct file' do
      it 'Should populate Deputy correctly' do
        expect {
          Populate::QuotasFileSource.new(file_fixture('2022.csv')).execute
        }.to change { Deputy.count }.from(2).to(8)
      end

      it 'Should populate Expenditure correctly' do
        expect {
          Populate::QuotasFileSource.new(file_fixture('2022.csv')).execute
        }.to change { Expenditure.count }.from(1).to(7)
      end

      it 'Should populate Organization correctly' do
        expect {
          Populate::QuotasFileSource.new(file_fixture('2022.csv')).execute
        }.to change { Organization.count }.from(3).to(5)
      end

      it 'Should populate Category correctly' do
        expect {
          Populate::QuotasFileSource.new(file_fixture('2022.csv')).execute
        }.to change { Category.count }.from(2).to(7)
      end
    end
  end
end
