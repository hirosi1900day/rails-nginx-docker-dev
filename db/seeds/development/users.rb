10.times do |n|
  name = "user#{n}"
  email = "#{name}@example.com"
  user = User.find_or_initialize_by(email:, activated: true)

  next unless user.new_record?

  user.name = name
  user.password = 'password'
  user.save!
end

puts "users = #{User.count}"
