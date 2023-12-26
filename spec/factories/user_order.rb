FactoryBot.define do
  factory(:user_order) do
    user
    content { Faker::Book.title }
    status { 0 }
  end
end
