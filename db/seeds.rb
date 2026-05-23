# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
# メインのサンプルユーザーを1人作成する
# 本番環境で既存ユーザーを管理者に昇格させる一時処理
# テストアカウント作成
admin_user = User.find_by(email: "admin@example.com")

if admin_user
  random_password = SecureRandom.urlsafe_base64(32)

  admin_user.update!(
    password: random_password,
    password_confirmation: random_password,
    admin: false
  )

  puts "====== [SUCCESS] admin@example.com has been disabled ======"
else
  puts "====== [INFO] admin@example.com was not found ======"
end