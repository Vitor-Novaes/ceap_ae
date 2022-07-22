
FactoryBot.define do
  factory :category do
    name { Faker::Lorem.paragraph(sentence_count: 1) }
  end
end
