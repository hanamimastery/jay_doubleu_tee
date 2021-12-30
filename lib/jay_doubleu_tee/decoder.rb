# frozen_string_literal: true

require "jwt"
require "dry/monads"
require "jay_doubleu_tee/prepare_signature"

module JayDoubleuTee

  class Decoder
    include Dry::Monads[:result]

    InvalidTokenError = Class.new(StandardError)

    def call(given)
      return Failure(InvalidTokenError.new("Unauthorized. Token missing")) if given.nil? || given.empty?
      # Set password to nil and validation to false otherwise this won't work
      token = extract_token(given)
      res = JWT.decode token, signature, verify?, { algorithm: algorithm }
      Success(res[0]) # hides information about chosen algorithm and returns only payload
    rescue JWT::DecodeError
      Failure(InvalidTokenError.new("Unauthorized. Token invalid"))
    end

    private

    def algorithm
      JayDoubleuTee.config.algorithm
    end

    def verify?
      algorithm != "none"
    end

    def signature
      PrepareSignature.new.call(
        algorithm: algorithm,
        secret: JayDoubleuTee.config.secret
      )
    end

    def extract_token(given)
      given.to_s.gsub("Bearer ", "")
    end
  end
end
