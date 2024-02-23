# api/app/services/user_auth/refresh_token.rb
require 'jwt'

module UserAuth
  class EncodeRefreshToken
    include TokenCommons

    attr_reader :user_id, :payload, :token

    def initialize(user_id: nil)
      @encode_user_id = encrypt_for(user_id)
    end

    def refresh_token
      payload = claims
      JWT.encode(payload, secret_key, algorithm, header_fields)
    end

    private

    # リフレッシュトークンの有効期限
    def token_lifetime
      UserAuth.refresh_token_lifetime
    end

    # 有効期限をUnixtimeで返す(必須)
    def token_expiration
      token_lifetime.from_now.to_i
    end

    # エンコード時のクレーム
    def claims
      {
        user_claim => @encode_user_id,
        exp: token_expiration
      }
    end
  end
end
