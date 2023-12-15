require 'rails_helper'

RSpec.describe 'keywords/index', type: :view do
  before(:each) do
    assign(:keywords, [
             Keyword.create!(
               content: 'content',
               status: 2,
               total_link: 3,
               total_result: 2,
               total_ad: 4
             ),
             Keyword.create!(
               content: 'content',
               status: 2,
               total_link: 3,
               total_result: 2,
               total_ad: 4
             )
           ])
  end

  it 'renders a list of keywords' do
    render
    cell_selector = Rails::VERSION::STRING >= '7' ? 'div>p' : 'tr>td'
    assert_select cell_selector, text: Regexp.new('content'.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(2.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(3.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(2.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(4.to_s), count: 2
  end
end
