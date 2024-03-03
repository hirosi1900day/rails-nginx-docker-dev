FactoryBot.define do
  factory :weight_histroy, class: 'WeightHistroy' do
    association :user
    weight { 100 }
    memo { 'memo' }
  end
end