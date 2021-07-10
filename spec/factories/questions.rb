FactoryBot.define do
  factory :question do
    title { "MyString" }
    body { "MyText" }

    trait :invalid do
      title { nil }
    end

    trait :with_attachment do
      after :create do |question|
        question.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"),
                              filename: 'rails_helper.rb')

        def question.filename
          files[0].filename.to_s
        end
      end
    end

    trait :created_at_yesterday do
      created_at { Date.today - 1 }
    end

    trait :created_at_more_yesterday do
      created_at { Date.today - 2 }
    end
  end
end
