# frozen_string_literal: true

require "dry/effects"
require "jay_doubleu_tee/decoder"

module JayDoubleuTee
  class Authorization
    include Dry::Effects::Handler.Reader(:auth)

    attr_reader :decoder, :config

    def initialize(app)
      @app = app
      @decoder = Decoder.new
      @config = JayDoubleuTee.config
    end

    def call(env)
      auth = decoder.call(env["HTTP_AUTHORIZATION"])

      return authorization_error(auth) if unauthorized?(auth)

      with_auth(auth) do
        @app.call(env)
      end
    end

    private

    def authorization_error(auth)
      headers = { 'Content-Type' => 'application/json' }
      [ 401, headers, [{ error: auth.failure }.to_json]]
    end

    def unauthorized?(auth)
      config.authorize_by_default && auth.failure?
    end
  end
end
