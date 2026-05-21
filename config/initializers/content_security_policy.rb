# Be sure to restart your server when you modify this file.

Rails.application.configure do
  config.content_security_policy do |policy|
    # デフォルト：同一オリジンのみ許可
    policy.default_src :self

    # フォント：self + data URI（Bootstrapのアイコン等で使用）
    policy.font_src :self, :data

    # 画像：HotPepper・Unsplash 等の外部HTTPS画像を許可
    policy.img_src :self, :https, :data

    # プラグイン（Flash等）：完全に禁止
    policy.object_src :none

    # スクリプト：self + Bootstrap CDN（nonce は nonce_generator が自動付与）
    policy.script_src :self, "https://cdn.jsdelivr.net"

    # スタイル：self + Bootstrap CDN + unsafe_inline（ビュー内 style= 属性のため）
    policy.style_src :self, :unsafe_inline, "https://cdn.jsdelivr.net"

    # Turbo の fetch ナビゲーション：同一オリジンのみ
    policy.connect_src :self

    # <base> タグのURLを同一オリジンに制限（base タグ挿入攻撃対策）
    policy.base_uri :self

    # フォーム送信先を同一オリジンに制限
    policy.form_action :self

    # iframe への埋め込みを全面禁止（クリックジャッキング対策）
    policy.frame_ancestors :none
  end

  # インラインscript をnonce で保護（リクエストごとにランダム生成）
  # importmap_tags / turbo-rails が生成するscriptタグにはRailsが自動でnonce を付与する
  # 手書きのインラインscriptには <%= request.content_security_policy_nonce %> で付与すること
  config.content_security_policy_nonce_generator = ->(_request) { SecureRandom.base64(16) }
  config.content_security_policy_nonce_directives = %w(script-src)
end
