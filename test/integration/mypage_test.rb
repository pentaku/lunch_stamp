require "test_helper"

class MypageTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
    log_in_as(@user)
  end

  # ─── アクセス ───────────────────────────────────────────────
  test "ログインなしではマイページにアクセスできない" do
    delete logout_path
    get user_path(@user)

    assert_redirected_to login_url
  end

  test "ログイン済みならマイページにアクセスできる" do
    get user_path(@user)
    assert_response :success
  end

  # ─── プロフィール ────────────────────────────────────────────
  test "ユーザー名が表示される" do
    get user_path(@user)
    assert_select "span.mypage-value", text: @user.name
  end

  test "メールアドレスが表示される" do
    get user_path(@user)
    assert_select "span.mypage-value", text: @user.email
  end

  test "プロフィール編集リンクが表示される" do
    get user_path(@user)
    assert_select "a[href=?]", edit_user_path(@user)
  end

  # ─── スタンプ進捗 ─────────────────────────────────────────────
  test "スタンプ進捗セクションのタイトルが表示される" do
    get user_path(@user)
    assert_match "人形町スタンプ進捗", response.body
  end

  test "訪問数が正しく表示される" do
    get user_path(@user)
    count = @user.visits.count
    assert_match "訪問数：#{count}", response.body
  end

  test "達成率が正しく計算・表示される" do
    get user_path(@user)
    count = @user.visits.count
    rate  = (count.to_f / 20 * 100).round
    assert_match "達成率：#{rate}%", response.body
  end

  test "プログレスバーが描画される" do
    get user_path(@user)
    assert_select ".mypage-progress-bar"
    assert_select ".mypage-progress-fill"
  end

  # ─── 訪問履歴（あり） ──────────────────────────────────────────
  test "訪問済み店舗名が表示される" do
    get user_path(@user)
    restaurant = @user.visits.first.restaurant
    assert_match restaurant.name, response.body
  end

  test "訪問済み店舗のエリア・ジャンル・予算が表示される" do
    get user_path(@user)
    restaurant = @user.visits.first.restaurant
    assert_match restaurant.area,   response.body
    assert_match restaurant.genre,  response.body
    assert_match restaurant.budget, response.body
  end

  test "訪問日が正しいフォーマットで表示される" do
    get user_path(@user)
    visit = @user.visits.order(visited_at: :desc).first
    assert_match visit.visited_at.strftime("%Y/%m/%d"), response.body
  end

  test "店舗詳細リンクが表示される" do
    get user_path(@user)
    restaurant = @user.visits.first.restaurant
    assert_select "a[href=?]", restaurant_path(restaurant.hotpepper_id)
  end

  # ─── 訪問履歴（なし） ──────────────────────────────────────────
  test "訪問記録がない場合、空状態メッセージが表示される" do
    no_visit_user = User.create!(
      name: "未訪問ユーザー",
      email: "novisit@example.com",
      password: "password",
      password_confirmation: "password",
      activated: true,
      activated_at: Time.zone.now
    )

    delete logout_path
    log_in_as(no_visit_user)

    get user_path(no_visit_user)

    assert_match "まだ訪問記録がありません", response.body
    assert_select "a[href=?]", restaurants_path
  end
end
