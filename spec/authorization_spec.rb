# frozen_string_literal: true

require 'rack'

class App
  include JayDoubleUti::Auth

  def call(env)
    if auth.success?
      body = ["Hello, World!\n#{auth.value!.to_json}"]
      [ 200, headers, body]
    else
      [ 401, headers, [{ error: auth.failure }.to_json]]
    end
  end

  private

  def headers
    { 'Content-Type' => 'application/json' }
  end
end


RSpec.describe JayDoubleUti::Authorization do
  let(:rack_env) { Rack::Request.new({}).env }
  let(:with_authorization) { JayDoubleUti::Authorization.new(App.new) }

  subject { with_authorization.call(rack_env) }

  context 'when unauthorized' do
    let(:status) { 401 }
    let(:headers) { { 'Content-Type' => 'application/json' } }
    let(:body) { { error: "Unauthorized. Token invalid" }.to_json }

    it 'returns unauthorized' do
      expect(subject).to eq([status, headers, [body]])
    end
  end

  context 'when authorized' do
    let(:status) { 200 }
    let(:headers) { { 'Content-Type' => 'application/json' } }
    let(:body) { "Hello, World!\n#{{ data: 'test' }.to_json}" }


    before do
      rack_env['HTTP_AUTHORIZATION'] = "Bearer eyJhbGciOiJub25lIn0.eyJkYXRhIjoidGVzdCJ9."
    end

    it 'returns unauthorized' do
      res = subject
      aggregate_failures do
        expect(subject[0]).to eq(status)
        expect(subject[1]).to eq(headers)
        expect(subject[2]).to eq([body])
      end
    end
  end
end