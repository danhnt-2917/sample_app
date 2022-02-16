# Create a main sample user.
User.create!(name: "Example User",
            email: "foobar@gmail.com",
            password: "123123",
            password_confirmation: "123123",
            admin: true,
            activated: true,
            activated_at: Time.zone.now)

# Generate a bunch of additional users.
50.times do |n|
  name = Faker::Name.name
  email = "foo-#{n+1}@railstutorial.org"
  password = "123123"
  User.create!(name: name,
              email: email,
              password: password,
              password_confirmation: password,
              activated: true,
              activated_at: Time.zone.now)
end

# Generate microposts for a subset of users.
users = User.order(:created_at).take(6)
50.times do
  content = Faker::Lorem.sentence(word_count: 5)
  users.each { |user| user.microposts.create!(content: content) }
end
