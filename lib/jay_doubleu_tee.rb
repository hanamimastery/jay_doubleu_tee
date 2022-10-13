# frozen_string_literal: true

require "dry-configurable"

require "jay_doubleu_tee/version"
require "jay_doubleu_tee/authorization"
require "jay_doubleu_tee/auth"

module JayDoubleuTee
  class Error < StandardError; end
  ConfigurationError = Class.new(Error)

  ALGORITHMS = %w[none HS256 RS256 prime256v1 ES256 ED25519 PS256]

  extend Dry::Configurable

  setting :algorithm, default: 'RS256', constructor: ->(value) do
    raise ConfigurationError, "Unsupported algorithm." unless ALGORITHMS.include?(value)
    value
  end

  setting :secret, default: ENV['JAY_DOUBLEU_TEE_PUBLIC_KEY']

  setting :authorize_by_default, default: true
end
