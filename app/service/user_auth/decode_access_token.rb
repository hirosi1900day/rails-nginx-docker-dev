# api/app/services/user_auth/auth_token.rb
require 'jwt'

module UserAuth
  class DecodeAccessToken
    include TokenCommons

    attr_reader :user_id, :payload, :lifetime, :token, :options

    def initialize(token: nil)
      @token = token
			payload = JWT.decode(@token.to_s, decode_key, true, verify_claims).first
      @encode_user_id = get_user_id_from(payload)
    end

    # 暗号化された@user_idからユーザーを取得する
    def entity_for_user
      User.find(decrypt_for(@encode_user_id))
    end

    private

		## エンコードメソッド

		# issuerの値がある場合にtrueを返す
		def verify_issuer?
			UserAuth.token_issuer.present?
		end

		# issuerを返す
		def token_issuer
			verify_issuer? && UserAuth.token_issuer
		end

		# audienceの値がある場合にtrueを返す
		def verify_audience?
			UserAuth.token_audience.present?
		end

		# audienceを返す
		def token_audience
			verify_audience? && UserAuth.token_audience
		end

		# user_idの値がある場合にtrueを返す
		def verify_user_id?
			@user_id.present?
		end

		# デコード時のデフォルトオプション
		# Doc: https://github.com/jwt/ruby-jwt
		# default: https://www.rubydoc.info/github/jwt/ruby-jwt/master/JWT/DefaultOptions
		def verify_claims
			{
				iss: token_issuer,
				aud: token_audience,
				sub: nil,
				verify_expiration: true,      # 有効期限の検証するか(必須)
				verify_iss: verify_issuer?,   # payloadとissの一致を検証するか
				verify_aud: verify_audience?, # payloadとaudの一致を検証するか
				verify_sub: false,  # payloadとsubの一致を検証するか
				algorithm: algorithm          # decode時のアルゴリズム
			}
		end
  end
end
