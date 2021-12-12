RSpec.describe JayDoubleuTee do
  it "has a version number" do
    expect(JayDoubleuTee::VERSION).not_to be nil
  end

  describe ".configure" do
    let(:algorithms) { JayDoubleuTee::ALGORITHMS }

    it 'sets defaults' do
      expect(described_class.config.algorithm).to eq('RS256')
      expect(described_class.config.secret).to eq(nil)
    end

    it 'configures algorithm' do
      aggregate_failures do
        algorithms.each do |algorithm|
          described_class.configure do |config|
            config.algorithm = algorithm
          end
          expect(described_class.config.algorithm).to eq(algorithm)
        end
      end
    end

    it 'raises the error for invalid algorithm value' do
      expect {
        described_class.configure do |config|
          config.algorithm = 'invalid'
        end
      }.to raise_error(JayDoubleuTee::ConfigurationError)
    end

    it 'configures secret' do
      described_class.configure do |config|
        config.secret = 'secret'
      end

      expect(described_class.config.secret).to eq('secret')
    end
  end
end
