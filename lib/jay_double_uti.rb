# frozen_string_literal: true

require "dry-configurable"

require "jay_double_uti/version"
require "jay_double_uti/authorization"
require "jay_double_uti/auth"

module JayDoubleUti
  class Error < StandardError; end
  ConfigurationError = Class.new(Error)

  ALGORITHMS = %w[none HS256 RS256 prime256v1 ES256 ED25519 PS256]

  extend Dry::Configurable
  setting :algorithm, default: 'none' do |value|
    raise ConfigurationError, "Unsupported algorithm." unless ALGORITHMS.include?(value)
    value
  end

  setting :secret, default: nil
end
