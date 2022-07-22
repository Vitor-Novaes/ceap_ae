FactoryBot.define do
  factory :organization do
    abbreviation { Faker::Name.initials(number: 3) }
  end
end
