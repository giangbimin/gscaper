FactoryBot.define do
  factory(:keyword) do
    content { Faker::Book.title }
    status { 1 }
    total_link { 1 }
    total_result { 1 }
    total_ad { 1 }
    html_code { '<div>htmlcode</div>' }
  end
end
