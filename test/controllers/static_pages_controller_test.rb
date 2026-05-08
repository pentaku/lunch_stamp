require "test_helper"

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  test "トップページにアクセスできる" do
    get root_url
    assert_response :success
  end

  test "利用規約ページに200でアクセスできる" do
    get terms_path
    assert_response :success
  end

  test "利用規約ページにタイトルが表示される" do
    get terms_path
    assert_select "h1.section-title-text", text: "利用規約"
  end

  test "利用規約ページに第1条が表示される" do
    get terms_path
    assert_match "第1条", response.body
  end

  test "利用規約ページに第15条が表示される" do
    get terms_path
    assert_match "第15条", response.body
  end
end
