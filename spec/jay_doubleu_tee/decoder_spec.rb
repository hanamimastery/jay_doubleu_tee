require 'jwt'
require 'jay_doubleu_tee/decoder'
require 'rbnacl'

RSpec.describe JayDoubleuTee::Decoder do
  let(:payload) { { data: 'test' } }
  subject { described_class.new }

  shared_examples_for "supported algorithm" do
    before do
      JayDoubleuTee.configure do |config|
        config.algorithm = algorithm
        config.secret = secret
      end
    end

    it "decodes valid token" do
      result = subject.call(token)
      expect(result).to be_success
      expect(result.value!).to eq("data" => "test")
    end

    it "raises an error for invalid token" do
      result = subject.call("invalid")
      expect(result).to be_failure
      expect(result.failure).to be_kind_of(described_class::InvalidTokenError)
      expect(result.failure.message).to eq("Unauthorized. Token invalid")
    end

    it "raises an error for nil" do
      result = subject.call(nil)
      expect(result).to be_failure
      expect(result.failure).to be_kind_of(described_class::InvalidTokenError)
      expect(result.failure.message).to eq("Unauthorized. Token missing")
    end
  end

  context "when no algorithm selected" do
    let(:algorithm) { 'none' }
    let(:secret) { nil }
    let(:token) { JWT.encode payload, nil, algorithm }

    it_behaves_like 'supported algorithm'
  end

  context "when HMAC algorithm selected" do
    let(:algorithm) { 'HS256' }
    let(:secret) { 'my$ecretK3y' }
    let(:token) { JWT.encode payload, secret, algorithm }

    it_behaves_like 'supported algorithm'
  end

  context "when RSA algorithm selected" do
    let(:algorithm) { 'RS256' }
    let(:private_key) { OpenSSL::PKey::RSA.generate 2048 }
    let(:secret) { private_key.public_key.to_s }
    let(:token) { JWT.encode payload, private_key, algorithm }

    it_behaves_like 'supported algorithm'
  end

  context "when ECDSA algorithm selected" do
    let(:algorithm) { 'ES256' }
    let(:private_key) { OpenSSL::PKey::EC.new 'prime256v1' }
    let(:secret) do
      private_key.generate_key
      ecdsa_public = OpenSSL::PKey::EC.new private_key
      ecdsa_public.private_key = nil
      ecdsa_public.to_pem
    end

    let(:token) { JWT.encode payload, private_key, algorithm }

    it_behaves_like 'supported algorithm'
  end

  context "when EDDSA algorithm selected" do
    let(:algorithm) { 'ED25519' }
    let(:private_key) { RbNaCl::Signatures::Ed25519::SigningKey.new('abcdefghijklmnopqrstuvwxyzABCDEF') }
    let(:secret) { private_key.verify_key.to_s }

    let(:token) { JWT.encode payload, private_key, algorithm }

    it_behaves_like 'supported algorithm'
  end

  context "when RSASSA-PSS algorithm selected" do
    let(:algorithm) { 'PS256' }
    let(:private_key) { OpenSSL::PKey::RSA.generate 2048 }
    let(:secret) { private_key.public_key.to_pem }

    let(:token) { JWT.encode payload, private_key, algorithm }

    it_behaves_like 'supported algorithm'
  end
end
