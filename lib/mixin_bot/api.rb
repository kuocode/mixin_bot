# frozen_string_literal: true

require_relative './client'
require_relative './errors'
require_relative './api/attachment'
require_relative './api/auth'
require_relative './api/blaze'
require_relative './api/conversation'
require_relative './api/me'
require_relative './api/message'
require_relative './api/multi_sign'
require_relative './api/payment'
require_relative './api/pin'
require_relative './api/snapshot'
require_relative './api/transfer'
require_relative './api/user'
require_relative './api/withdraw'

module MixinBot
  class API
    attr_reader :client_id, :client_secret, :session_id, :pin_token, :private_key
    attr_reader :client, :blaze_host

    def initialize(options = {})
      @client_id = options[:client_id] || MixinBot.client_id
      @client_secret = options[:client_secret] || MixinBot.client_secret
      @session_id = options[:session_id] || MixinBot.session_id
      @pin_token = Base64.decode64 options[:pin_token] || MixinBot.pin_token
      @private_key = OpenSSL::PKey::RSA.new options[:private_key] || MixinBot.private_key
      @client = Client.new(MixinBot.api_host)
      @blaze_host = MixinBot.blaze_host || 'blaze.mixin.one'
    end

    include MixinBot::API::Attachment
    include MixinBot::API::Auth
    include MixinBot::API::Blaze
    include MixinBot::API::Conversation
    include MixinBot::API::Me
    include MixinBot::API::Message
    include MixinBot::API::MultiSign
    include MixinBot::API::Payment
    include MixinBot::API::Pin
    include MixinBot::API::Snapshot
    include MixinBot::API::Transfer
    include MixinBot::API::User
    include MixinBot::API::Withdraw
  end
end
