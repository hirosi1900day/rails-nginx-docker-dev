# api/app/services/user_auth/refresh_token.rb
require 'jwt'

module UserAuth
  class DecodeRefreshToken
    include TokenCommons

    attr_reader :user_id, :payload, :token

    def initialize(token: nil)
      # decode
      @token = token
      @payload = JWT.decode(@token.to_s, decode_key, true, verify_claims).first
      @encode_user_id = get_user_id_from(@payload)
    end

    # 暗号化されたuserIDからユーザーを取得する
    def entity_for_user
      id = decrypt_for(@encode_user_id)
      User.find(decrypt_for(id))
    end

    private
    
    # デコード時のデフォルトオプション
    # Doc: https://github.com/jwt/ruby-jwt
    # default: https://www.rubydoc.info/github/jwt/ruby-jwt/master/JWT/DefaultOptions
    def verify_claims
      {
        verify_expiration: true,           # 有効期限の検証するか(必須)
        algorithm: algorithm               # decode時のアルゴリズム
      }
    end
  end
end
