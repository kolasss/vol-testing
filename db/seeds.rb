# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Users::User.create!(
  nickname: Faker::Name.name,
  email:    'admin@test.org',
  password: 'password',
  role:     'Administrator'
)

5.times do
  user = Users::User.create!(
    nickname: Faker::Name.name,
    email:    Faker::Internet.unique.email,
    password: 'password',
    role:     'Blogger'
  )
  Random.new.rand(5..15).times do
    Post.create!(
      title:        Faker::StarWars.character,
      body:         Faker::StarWars.quote,
      published_at: Faker::Time.between(3.days.ago, 1.days.ago, :all),
      author: user
    )
  end
end

