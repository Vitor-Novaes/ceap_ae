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
    after :create do |deputy|
      deputy.expenditures = create_list(:expenditure, 2, deputy: deputy)
    end
  end
end
