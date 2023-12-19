require 'rails_helper'

RSpec.describe 'keywords/index', type: :view do
  before(:each) do
    current_user = create(:user)
    keywords = [
      create(:keyword, content: 'Keyword content 1', status: :processed, total_link: 3, total_result: 2, total_ad: 4),
      create(:keyword, content: 'Keyword content 2', status: :pending, total_link: 3, total_result: 2, total_ad: 4)
    ]
    sign_in current_user
    assign(:keywords, keywords)
  end

  it 'renders a list of keywords' do
    render
    expect(rendered).to match(/Keyword content 1/)
    expect(rendered).to match(/Keyword content 2/)
    expect(rendered).to match(/pending/)
    expect(rendered).to match(/processed/)
    cell_selector = 'td>span'
    assert_select cell_selector, text: Regexp.new(3.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(2.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(4.to_s), count: 2
  end
end
