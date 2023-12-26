class KeywordSerializer
  include JSONAPI::Serializer
  attributes :id, :content, :status, :total_link, :total_result, :total_ad, :html_code
end
