
FactoryBot.define do
  factory :category do
    name { Faker::Name.unique.name }
  end

  trait :with_expenditure do
    transient do
      expenditure_count { 1 }
    end

    after :create do |category, evaluator|
      create_list(:expenditure, evaluator.expenditure_count, category: category)
    end
  end
end
