FactoryBot.define do
  factory(:keyword) do
    content { Faker::Book.title }
    user_order
    status { 0 }
    total_link { 0 }
    total_result { 0 }
    total_ad { 0 }
  end
end
