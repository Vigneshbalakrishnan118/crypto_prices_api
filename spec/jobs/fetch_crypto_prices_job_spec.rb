require "rails_helper"

RSpec.describe FetchCryptoPricesJob do
  subject(:job) { described_class.new }

  let(:fetcher) { instance_double(CryptoPriceFetcher) }

  before do
    allow(CryptoPriceFetcher)
      .to receive(:new)
      .and_return(fetcher)

    allow(fetcher)
      .to receive(:call)
  end

  it "fetches every supported symbol" do
    SUPPORTED_SYMBOLS.each do |symbol|
      expect(fetcher)
        .to receive(:call)
        .with(symbol)
    end

    job.perform
  end
end
