# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
# メインのサンプルユーザーを1人作成する

if Rails.env.production?
  admin_user = User.find_by(email: "ohara1728136@gmail.com")

  if admin_user
    admin_user.update!(admin: true)
    puts "====== [SUCCESS] Admin privilege granted to #{admin_user.email} ======"
  else
    puts "====== [WARNING] Admin target user not found in production database ======"
  end
end
