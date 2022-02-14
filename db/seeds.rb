# Create a main sample user.
User.create!(name: "Example User",
            email: "foobar@gmail.com",
            password: "123123",
            password_confirmation: "123123",
            admin: true,
            activated: true,
            activated_at: Time.zone.now)

# Generate a bunch of additional users.
99.times do |n|
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
