FactoryBot.define do
  factory :document do
    status { 1 }
    requested_at {  }
    delivered_at { "2022-10-27" }
    project { nil }
    documentable { nil }
  end

  factory :project do
    user
    name { "Test Project" }
    start_date { Date.today - 5.days }
    end_date { nil }
  end

  factory :user do
    sequence(:full_name) { |n| "user #{n}" }
    role { 0 }
    email { |n| "user#{n}@test.com" }
  end
end
