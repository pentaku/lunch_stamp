require "test_helper"

class AuditLogsControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user       = users(:michael)
    @restaurant = restaurants(:two)
  end

  # ─── アクセス制御 ────────────────────────────────────────────
  test "未ログイン時はindexにアクセスできない" do
    get audit_logs_path
    assert_redirected_to login_url
  end

  test "ログイン済みはindexにアクセスできる" do
    log_in_as(@user)
    get audit_logs_path
    assert_response :success
  end

  # ─── CSV ────────────────────────────────────────────────────
  test "ログイン済みはCSVをダウンロードできる" do
    log_in_as(@user)
    get export_csv_audit_logs_path(format: :csv)
    assert_response :success
    assert_equal "text/csv; charset=utf-8", response.content_type
  end

  # ─── 監査ログ作成 ─────────────────────────────────────────────
  test "ログイン成功時に監査ログが作成される" do
    assert_difference "AuditLog.count", 1 do
      post login_path, params: {
        session: {
          email:    @user.email,
          password: "password",
        },
      }
    end
    assert_equal "login", AuditLog.last.action
  end

  test "ログアウト時に監査ログが作成される" do
    log_in_as(@user)
    assert_difference "AuditLog.count", 1 do
      delete logout_path
    end
    assert_equal "logout", AuditLog.last.action
  end

  test "訪問済み登録時にvisit_createの監査ログが作成される" do
    log_in_as(@user)
    original_method = HotpepperService.method(:find)
    dummy_shop = {
      "id"         => @restaurant.hotpepper_id,
      "name"       => @restaurant.name,
      "address"    => @restaurant.address,
      "genre"      => { "name" => @restaurant.genre },
      "small_area" => { "name" => @restaurant.area },
      "budget"     => { "name" => @restaurant.budget },
      "photo"      => { "pc" => { "l" => @restaurant.photo_url } },
      "urls"       => { "pc" => @restaurant.url },
    }
    HotpepperService.define_singleton_method(:find) { |_id| dummy_shop }

    assert_difference "AuditLog.count", 1 do
      post restaurant_visit_path(@restaurant.hotpepper_id)
    end
    assert_equal "visit_create", AuditLog.last.action
    assert_equal "Restaurant", AuditLog.last.target_type
  ensure
    HotpepperService.define_singleton_method(:find, original_method)
  end

  test "訪問済み解除時にvisit_destroyの監査ログが作成される" do
    log_in_as(@user)
    Visit.create!(
      user:       @user,
      restaurant: @restaurant,
      visited_at: Date.current,
    )
    assert_difference "AuditLog.count", 1 do
      delete restaurant_visit_path(@restaurant.hotpepper_id)
    end
    assert_equal "visit_destroy", AuditLog.last.action
    assert_equal "Restaurant", AuditLog.last.target_type
  end

end