# api/app/services/user_sessionize_service.rb
module UserSessionizeService
  # セッションユーザーが居ればtrue、存在しない場合は401を返す
  def sessionize_user
    session_user.present? || head(:unauthorized)
  end

  # セッションキー
  def session_key
    UserAuth.session_key
  end

  private

  # リクエストヘッダートークンを取得する
  def refresh_token_from_request_headers
    request.headers['Authorization']&.split&.last
  end

  # refresh_tokenから有効なユーザーを取得する
  def fetch_user_from_refresh_token
    UserAuth::DecodeRefreshToken.new(token: refresh_token_from_request_headers).entity_for_user
  rescue UserAuth.not_found_exception_class,
         JWT::DecodeError, JWT::EncodeError
    nil
  end

  # refresh_tokenのユーザーを返す
  def session_user
    return nil unless refresh_token_from_request_headers

    @_session_user ||= fetch_user_from_refresh_token
  end

  # jtiエラーの処理
  def catch_invalid_jti
    delete_session
    raise JWT::InvalidJtiError
  end
end
