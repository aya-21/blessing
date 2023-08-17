class ApplicationController < ActionController::Base
  add_flash_types :success, :info, :warning, :danger
  before_action :require_login

  def not_authenticated
    flash[:warning] = t('defaults.message.require_login')
    redirect_to login_path
  end

  private

  def require_login
    unless logged_in? # `logged_in?`は現在のユーザーがログインしているかどうかを確認するメソッドと仮定
      redirect_to login_path, alert: "ログインが必要です"
    end
  end
end