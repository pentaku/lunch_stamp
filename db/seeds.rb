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
test_user = User.find_or_initialize_by(email: "test@example.com")
test_user.assign_attributes(
  name: "テストユーザー",
  password: "password",
  password_confirmation: "password",
  activated: true,
  activated_at: Time.current,
  admin: false,
)
test_user.save!

admin_user = User.find_or_initialize_by(email: "admin@example.com")
admin_user.assign_attributes(
  name: "管理者ユーザー",
  password: "password",
  password_confirmation: "password",
  activated: true,
  activated_at: Time.current,
  admin: true,
)
admin_user.save!