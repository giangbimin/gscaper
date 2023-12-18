user = User.create(email: "example@example.com", password: "example@12345" )
["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
  keyword = Keyword.create(content: genre_name)
  UserKeyword.create(user: user, keyword: keyword)
end
