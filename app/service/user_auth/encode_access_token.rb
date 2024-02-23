# api/app/services/user_auth/auth_token.rb
require 'jwt'

module UserAuth
  class EncodeAccessToken
    include TokenCommons

    attr_reader :user_id, :payload, :lifetime, :token, :options

    def initialize(user_id: nil)
      @encode_user_id = encrypt_for(user_id)
      @lifetime = UserAuth.access_token_lifetime
    end

    def access_token
      payload = claims
      JWT.encode(payload, secret_key, algorithm, header_fields)
    end

    private

    # issuerを返す
    def token_issuer
      UserAuth.token_issuer
    end

    # audienceを返す
    def token_audience
      UserAuth.token_audience
    end

    # user_idの値がある場合にtrueを返す
    def verify_user_id?
      @encode_user_id.present?
    end

    # 有効期限をUnixtimeで返す(必須)
    def token_expiration
      @lifetime.from_now.to_i
    end

    # エンコード時のクレーム
    def claims
      _claims = {}
      _claims[:exp] = token_expiration
      _claims[user_claim] = @encode_user_id if verify_user_id?
      _claims[:iss] = token_issuer
      _claims[:aud] = token_audience
      _claims
    end
  end
end
