FactoryBot.define do
  factory :deputy do
    cpf { Faker::IDNumber.valid }
    ide { Faker::Number.number(digits: 5) }
    parlamentary_card { Faker::Number.number(digits: 5) }
    name { Faker::Name.name }
    state { Faker::Address.state }
    association :organization, strategy: :build
  end

  trait :with_expenditures do
    transient do
      expenditure_count { 5 }
    end

    after :create do |deputy, evaluator|
      create_list(:expenditure, evaluator.expenditure_count, deputy: deputy)
    end
  end
end
