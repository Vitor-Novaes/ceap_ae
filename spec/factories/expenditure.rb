FactoryBot.define do
  factory :expenditure do
    description { Faker::Lorem.paragraph(sentence_count: 1) }
    especification { Faker::Lorem.paragraph(sentence_count: 1) }
    provider { Faker::Name.name }
    provider_documentation { Faker::IDNumber.valid }
    date { Faker::Date.between(from: 2.days.ago, to: Date.today) }
    period { [2018, 2019, 2020, 2021].sample }
    net_value { Faker::Number.decimal(l_digits: 3, r_digits: 2) }
    receipt_type { %w[INVOICE RECEIPT EXPENSES_ABROAD NO_SPECIFIED].sample }
    receipt_url { Faker::Internet.url }
    association :deputy, strategy: :build
  end
end
