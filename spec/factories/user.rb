FactoryBot.define do
  factory :user, class: 'User' do
    name { 'name' }
    email { 'email@email.com' }
    password_digest { 'password' }
    activated { false }
    admin { false }
  end
end