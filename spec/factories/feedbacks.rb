FactoryBot.define do
  factory :feedback do
    rating { 1 }
    comment { 'Some feedback text' }
    vacancy
  end
end
