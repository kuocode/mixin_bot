# frozen_string_literal: true

require_relative './client'
require_relative './errors'
require_relative './api/app'
require_relative './api/attachment'
require_relative './api/auth'
require_relative './api/blaze'
require_relative './api/conversation'
require_relative './api/me'
require_relative './api/message'
require_relative './api/multisig'
require_relative './api/payment'
require_relative './api/pin'
require_relative './api/snapshot'
require_relative './api/transfer'
require_relative './api/user'
require_relative './api/withdraw'

module MixinBot
  class API
    attr_reader :client_id, :client_secret, :session_id, :pin_token, :private_key, :client, :blaze_host, :schmoozer

    def initialize(options = {})
      @client_id = options[:client_id] || MixinBot.client_id
      @client_secret = options[:client_secret] || MixinBot.client_secret
      @session_id = options[:session_id] || MixinBot.session_id
      @pin_token = Base64.urlsafe_decode64 options[:pin_token] || MixinBot.pin_token
      @client = Client.new(MixinBot.api_host || 'api.mixin.one')
      @blaze_host = MixinBot.blaze_host || 'blaze.mixin.one'
      _private_key = options[:private_key] || MixinBot.private_key
      @private_key =
        if /^-----BEGIN RSA PRIVATE KEY-----/.match? _private_key
          _private_key.gsub('\\r\\n', "\n").gsub("\r\n", "\n")
        else
          Base64.urlsafe_decode64 _private_key
        end
    end

    # Use a mixin software to implement transaction build
    def build_transaction(json)
      ensure_mixin_command_exist
      command = format("mixin signrawtransaction --raw '%<arg>s'", arg: json)

      output, error = Open3.capture3(command)
      raise error unless error.empty?

      output.chomp
    end

    include MixinBot::API::App
    include MixinBot::API::Attachment
    include MixinBot::API::Auth
    include MixinBot::API::Blaze
    include MixinBot::API::Conversation
    include MixinBot::API::Me
    include MixinBot::API::Message
    include MixinBot::API::Multisig
    include MixinBot::API::Payment
    include MixinBot::API::Pin
    include MixinBot::API::Snapshot
    include MixinBot::API::Transfer
    include MixinBot::API::User
    include MixinBot::API::Withdraw

    private

    def ensure_mixin_command_exist
      return if command?('mixin')

      raise '`mixin` command is not valid!'
    end

    def command?(name)
      `which #{name}`
      $CHILD_STATUS.success?
    end
  end
end
