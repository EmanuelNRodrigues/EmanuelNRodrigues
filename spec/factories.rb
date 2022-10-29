# frozen_string_literal: true

FactoryBot.define do
  factory :project_doc do
    version { 'v1' }
  end

  factory :accounting_doc do
    sequence(:value) { |n| "#{n}.12" }
    date { Date.today }
  end

  factory :government_doc do
    entity { 'Camara Municipal' }
    date { Date.today }
  end

  factory :architect_office_doc do
  end

  factory :document do
    project
    association :documentable, factory: :architect_office_doc
    description { 'This is a description' }
    delivered_at { Date.today }

    trait :architect_office do
      sequence(:description) { |n| "Proposta de valor n: #{n}" }
    end

    trait :government do
      sequence(:description) { |n| "Resposta da Camara #{n}" }
      association :documentable, factory: :government_doc
    end

    trait :accounting do
      sequence(:description) { |n| "Fatura #{n}" }
      association :documentable, factory: :accounting_doc
    end

    trait :project do
      sequence(:description) { |n| "Risco n: #{n}" }
      association :documentable, factory: :project_doc
    end
  end

  factory :project do
    user
    name { 'Test Project' }
    start_date { Date.today - 5.days }
    end_date { nil }
  end

  factory :user do
    sequence(:full_name) { |n| "user #{n}" }
    role { 0 }
    sequence(:email) { |n| "user#{n}@test.com" }
  end
end
