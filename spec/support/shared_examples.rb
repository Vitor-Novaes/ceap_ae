shared_examples 'ok request' do
  it { expect(response).to have_http_status(:ok) }
end

shared_examples 'not found' do
  it { expect(response).to have_http_status(:not_found) }
end
