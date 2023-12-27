class KeywordsSerializer
  include JSONAPI::Serializer
  attributes :id, :content, :status, :total_link, :total_result, :total_ad
end
