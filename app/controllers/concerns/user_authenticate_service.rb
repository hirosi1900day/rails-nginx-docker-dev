# api/app/services/user_authenticate_service.rb
module UserAuthenticateService
  # 認証（トークンの持ち主を判定）
  # 認証済みのユーザーが居ればtrue、存在しない場合は401を返す
  def authenticate_user
    current_user.present? || head(:unauthorized)
  end

  # 2021.12.20 追加
  # 保護リソースには認証・認可を行うこちらのメソッドを使用してください。
  # 認証 & 認可（トークンの持ち主 && メール認証ユーザーを判定）
  # 認証済み && メール認証済みのユーザーが居ればtrue、存在しない場合は401を返す
  def authenticate_active_user
    (current_user.present? && current_user.activated?) || head(:unauthorized)
  end

  private

  # リクエストヘッダートークンを取得する
  def access_token_from_request_headers
    request.headers["Authorization"]&.split&.last
  end

  # access_tokenから有効なユーザーを取得する
  def fetch_user_from_access_token
    UserAuth.new(token: access_token_from_request_headers).entity_for_user
  rescue UserAuth.not_found_exception_class,
          JWT::DecodeError, JWT::EncodeError
    nil
  end

  # tokenのユーザーを返す
  def current_user
    return nil unless access_token_from_request_headers
    @_current_user ||= fetch_user_from_access_token
  end
end