# frozen_string_literal: true

require 'rack'

class App
  include JayDoubleuTee::Auth

  def call(env)
    msg = (auth.success? ? auth.value! : auth.failure).to_json
    status, body = [200, ["Hello, World! #{msg}"]]
    [status, headers, body]
  end

  private

  def headers
    { 'Content-Type' => 'application/json' }
  end
end


RSpec.describe JayDoubleuTee::Authorization do
  let(:rack_env) { Rack::Request.new({}).env }
  let(:with_authorization) { JayDoubleuTee::Authorization.new(App.new) }
  let(:payload) { { data: 'test' } }
  let(:algorithm) { 'RS256' }
  let(:private_key) { OpenSSL::PKey::RSA.generate 2048 }
  let(:secret) { private_key.public_key.to_s }
  let(:token) { JWT.encode payload, private_key, algorithm }

  subject { with_authorization.call(rack_env) }

  before do
    JayDoubleuTee.configure do |config|
      config.secret = secret
    end
  end

  context 'when token missing' do
    let(:status) { 401 }
    let(:headers) { { 'Content-Type' => 'application/json' } }
    let(:body) { { error: "Unauthorized. Token missing" }.to_json }

    it 'returns unauthorized' do
      expect(subject).to eq([status, headers, [body]])
    end
  end

  context 'when token invalid' do
    let(:status) { 401 }
    let(:headers) { { 'Content-Type' => 'application/json' } }
    let(:body) { { error: "Unauthorized. Token invalid" }.to_json }

    before do
      rack_env['HTTP_AUTHORIZATION'] = "Bearer invalid"
    end

    it 'returns unauthorized' do
      expect(subject).to eq([status, headers, [body]])
    end
  end

  context 'when not authorized by default' do
    let(:status) { 200 }
    let(:headers) { { 'Content-Type' => 'application/json' } }
    let(:body) { "Hello, World! \"Unauthorized. Token missing\"" }

    it 'returns authorized response' do
      JayDoubleuTee.config.authorize_by_default = false
      res = subject
      aggregate_failures do
        expect(subject[0]).to eq(status)
        expect(subject[1]).to eq(headers)
        expect(subject[2]).to eq([body])
      end
      JayDoubleuTee.config.authorize_by_default = true
    end
  end

  context 'when authorized' do
    let(:status) { 200 }
    let(:headers) { { 'Content-Type' => 'application/json' } }
    let(:body) { "Hello, World!\n#{{ data: 'test' }.to_json}" }

    before do
      rack_env['HTTP_AUTHORIZATION'] = "Bearer #{token}"
    end

    it 'returns authorized respons' do
      res = subject
      aggregate_failures do
        expect(subject[0]).to eq(status)
        expect(subject[1]).to eq(headers)
        expect(subject[2]).to eq([body])
      end
    end
  end
end
