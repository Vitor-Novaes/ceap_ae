module Request
  module HeaderHelpers
    def api_response_format
      request.headers['Accept'] = 'application/json'
      request.headers['Content-Type'] = 'application/json'
    end
  end
end

RSpec.configure do |config|
  config.include Request::HeaderHelpers, type: :controller
  config.before(:each, type: :controller) do
    api_response_format
  end
end
