describe DataService::OpenDataQuotasFile do
  describe '#download_by_year' do
    context 'When called it without error request' do
      it 'Should return unzip file by year' do
        stub_request(:get, 'https://www.camara.leg.br/cotas/Ano-2022.csv.zip')
         .with(
            headers: {
              'Accept'=>'*/*',
              'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
              'User-Agent'=>'Ruby'
           })
         .to_return(status: 200, body: file_fixture('Ano-2022.csv.zip'), headers: {})

        file = DataService::OpenDataQuotasFile.new.download_by_year(2022)

        expect(File.basename(file)).to eq('2022.csv')
      end
    end

    context 'When called it with error request' do
      it 'Should return error if service not available', skip: :true do
        allow(Time).to receive_message_chain(:now, :year) { 2022 }
        request_2022 = stub_request(:get, 'https://www.camara.leg.br/cotas/Ano-2022.csv.zip')
          .with(
            headers: {
              'Accept'=>'*/*',
              'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
              'User-Agent'=>'Ruby'
           })
         .to_return(status: 503, body: '', headers: {})

        expect(DataService::OpenDataQuotasFile.new.download_by_year(2022))
          .to raise_error(HTTParty::Error, 'Error HTTParty with 503')
        expect(request_2022).to have_been_requested
      end

      it 'Should return unzip file past year case file year not available yet' do
        allow(Time).to receive_message_chain(:now, :year) { 2023 }
        request_2023 = stub_request(:get, 'https://www.camara.leg.br/cotas/Ano-2023.csv.zip')
          .with(
            headers: {
              'Accept'=>'*/*',
              'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
              'User-Agent'=>'Ruby'
            })
          .to_return(status: 404, body: '', headers: {})

        request_2022 = stub_request(:get, 'https://www.camara.leg.br/cotas/Ano-2022.csv.zip')
          .with(
            headers: {
              'Accept'=>'*/*',
              'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
              'User-Agent'=>'Ruby'
            })
          .to_return(status: 200, body: file_fixture('Ano-2022.csv.zip'), headers: {})

        file = DataService::OpenDataQuotasFile.new.download_by_year(2023)

        expect(File.basename(file)).to eq('2022.csv')
        expect(request_2023).to have_been_requested
        expect(request_2022).to have_been_requested
      end
    end
  end
end
