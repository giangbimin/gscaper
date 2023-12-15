require 'rails_helper'

RSpec.describe 'keywords/new', type: :view do
  before(:each) do
    assign(:keyword, Keyword.new(
                       content: 'MyString',
                       status: 1,
                       total_link: 1,
                       total_result: 2,
                       total_ad: 1
                     ))
  end

  it 'renders new keyword form' do
    render

    assert_select 'form[action=?][method=?]', keywords_path, 'post' do
      assert_select 'input[name=?]', 'keyword[content]'
    end
  end
end
