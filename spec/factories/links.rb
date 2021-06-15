FactoryBot.define do
  factory :link do
    name { "MyString" }
    url { 'http://yandex.ru'}

    trait :linkable do
      association :linkable, factory: :answer
    end

    trait :valid_gist do
      url { 'https://gist.github.com/alex-b1/ba9f1444dffa83bb8061eed5bb8b35d2' }
    end

    trait :invalid_gist do
      url { 'https://gist.github.com/alex-b1/' }
    end
  end
end
