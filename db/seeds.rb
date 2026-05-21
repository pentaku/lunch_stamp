# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
# メインのサンプルユーザーを1人作成する
admin_user = User.find_or_create_by!(email: "ohara1728136@gmail.com") do |user|
  user.name = "Example User"
  user.password = "password"
  user.password_confirmation = "password"
  user.activated = true
  user.activated_at = Time.zone.now
end

if Rails.env.production?
  admin_user = User.find_by(email: "ohara1728136@gmail.com")

  if admin_user
    admin_user.update!(admin: true)
    puts "====== [SUCCESS] Admin privilege granted to #{admin_user.email} ======"
  else
    puts "====== [WARNING] User not found in production database ======"
  end
end
