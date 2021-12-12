# frozen_string_literal: true

require "jwt"

module JayDoubleuTee
  class PrepareSignature
    def call(algorithm:, secret:)
      return OpenSSL::PKey::RSA.new(secret) if algorithm == "RS256"
      return OpenSSL::PKey::EC.new(secret) if algorithm == "ES256"
      return RbNaCl::Signatures::Ed25519::VerifyKey.new(secret) if algorithm == "ED25519"
      return OpenSSL::PKey::RSA.new(secret) if algorithm == "PS256"

      secret
    end
  end
end
