# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
User.create!(name:  "Example User",
             email: "example@railstutorial.org",
             password:              "foobar",
             password_confirmation: "foobar",
             admin: true,
             activated: true,
             activated_at: Time.zone.now)

99.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(name:  name,
              email: email,
              password:              password,
              password_confirmation: password,
              activated: true,
              activated_at: Time.zone.now)
end

users = User.order(:created_at).limit(6)

# 初期フィード用の固定文言。ランダム生成（Faker）だと不適切な語が混じることがあるため、
# クリーンな固定文にしている。モデレーション機能のデモは本番でライブ投稿して見せる。
# seed投稿はモデレーションを通さないので processing_state は done 固定。
demo_microposts = [
  "今日は天気が良いので散歩に行きました。",
  "新しく開いたカフェでコーヒーを飲んでいます。",
  "週末は友人と映画を観に行く予定です。",
  "最近プログラミングの勉強を始めました。",
  "おすすめの本があればぜひ教えてください。",
  "近所で美味しいラーメン屋さんを見つけました。"
]

demo_microposts.each_with_index do |content, i|
  user = users[i % users.size]
  user.microposts.create!(content: content, processing_state: :done)
end

# リレーションシップ
users = User.all
user  = users.first
following = users[2..50]
followers = users[3..40]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }
