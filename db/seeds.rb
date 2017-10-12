# Users::User.create!(
#   nickname: Faker::Name.name,
#   email:    'admin@test.org',
#   password: 'password',
#   role:     'Administrator'
# )

5.times do
  user = Users::User.create!(
    nickname: Faker::Name.name,
    email:    Faker::Internet.unique.email,
    password: 'password',
    role:     'Blogger'
  )
  Random.new.rand(5..15).times do
    post = Post.create!(
      title:        Faker::StarWars.character,
      body:         Faker::StarWars.quote,
      published_at: Faker::Time.between(3.days.ago, 1.days.ago, :all),
      author: user
    )

    Random.new.rand(2..10).times do
      author_id = Users::User.ids.sample
      Comment.create!(
        body:         Faker::Overwatch.quote,
        published_at: Faker::Time.between(post.published_at, Time.current, :all),
        author_id:    author_id,
        post:         post
      )
    end
  end
end

