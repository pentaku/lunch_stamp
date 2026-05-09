require "test_helper"

class HomeTest < ActionDispatch::IntegrationTest

  # ─── アクセス ────────────────────────────────────────────────
  test "トップページに200でアクセスできる" do
    get root_path
    assert_response :success
  end

  # ─── コンセプトセクション ──────────────────────────────────────
  test "キャッチコピーが表示される" do
    get root_path
    assert_select "h1.home-hero-title", text: "人形町ランチを制覇しよう。"
  end

  test "サブテキストが表示される" do
    get root_path
    assert_match "人形町のランチ店を探して、行ったお店を記録できます", response.body
  end

  test "ヒーロー画像が表示される" do
    get root_path
    assert_select "img.home-hero-img"
  end

  # ─── CTA ────────────────────────────────────────────────────
  test "未ログイン時は新規登録リンクが表示される" do
    get root_path
    assert_select "a.home-cta-link[href=?]", signup_path, text: "新規登録はこちら"
  end

  test "ログイン済みはお店を探すリンクが表示される" do
    log_in_as(users(:michael))
    get root_path
    assert_select "a.home-cta-link[href=?]", restaurants_path, text: "お店を探す"
    assert_select "a.home-cta-link[href=?]", signup_path, count: 0
  end

  # ─── できることセクション ─────────────────────────────────────
  test "ランチスタンプでできることセクションが表示される" do
    get root_path
    assert_select "h2.section-title-text", text: "ランチスタンプでできること"
  end

  test "3つの機能項目が表示される" do
    get root_path
    assert_select ".home-feature-item", count: 3
  end

  test "お店を探す機能が表示される" do
    get root_path
    assert_match "お店を探す", response.body
  end

  test "ランチを記録機能が表示される" do
    get root_path
    assert_match "ランチを記録", response.body
  end

  test "進捗を確認機能が表示される" do
    get root_path
    assert_match "進捗を確認", response.body
  end
end
