FactoryBot.define do
  factory :badge do
    title { "Badge" }
  end

  trait :has_image do
    image { Rack::Test::UploadedFile.new("#{Rails.root}/spec/rails_helper.rb") }
  end
end
