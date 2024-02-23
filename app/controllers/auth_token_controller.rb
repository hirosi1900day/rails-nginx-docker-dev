# api/app/controllers/api/v1/auth_token_controller.rb
class AuthTokenController < ApplicationController
  include UserSessionizeService

  # 404エラーが発生した場合にヘッダーのみを返す
  rescue_from UserAuth.not_found_exception_class, with: :not_found
  # refresh_tokenのInvalidJitErrorが発生した場合はカスタムエラーを返す
  rescue_from JWT::InvalidJtiError, with: :invalid_jti

  # userのログイン情報を確認する
  before_action :authenticate, only: [:create]

  # ログイン
  def create
    render json: {
      token: access_token,
      expires: access_token_expiration,
      refresh_token:
    }
  end

  # リフレッシュ
  def refresh
    head(:unauthorized) and return if session_user.blank?

    render json: {
      token: access_token,
      expires: access_token_expiration,
      refresh_token:
    }
  end

  private

  # ログインユーザーが居ない、もしくはpasswordが一致しない場合404を返す
  def authenticate
    ## sessionを送っているユーザーが現在ログイン中かを確認する
  end

  # ログイン時のデフォルトレスポンス
  def login_response
    {
      token: access_token,
      expires: access_token_expiration
    }
  end

  # リフレッシュトークンのインスタンス生成
  def encode_refresh_token
    @encode_refresh_token ||= @user.encode_refresh_token
  end

  # リフレッシュトークン
  def refresh_token
    encode_refresh_token.token
  end

  # リフレッシュトークンの有効期限
  def refresh_token_expiration
    Time.zone.at(encode_refresh_token.payload[:exp])
  end

  # アクセストークンのインスタンス生成
  def encode_access_token
    @encode_access_token ||= @user.encode_access_token
  end

  # アクセストークン
  def access_token
    encode_access_token.token
  end

  # アクセストークンの有効期限
  def access_token_expiration
    encode_access_token.payload[:exp]
  end

  # アクセストークンのsubjectクレーム
  def access_token_subject
    encode_access_token.payload[:sub]
  end

  # 404ヘッダーのみの返却を行う
  # Doc: https://gist.github.com/mlanett/a31c340b132ddefa9cca
  def not_found
    head(:not_found)
  end

  # decode jti != user.refresh_jti のエラー処理
  def invalid_jti
    msg = 'Invalid jti for refresh token'
    render status: :unauthorized, json: { status: 401, error: msg }
  end

  def auth_params
    params.require(:auth).permit(:email, :password)
  end
end
