require 'rails_helper'

RSpec.describe 'keywords/show', type: :view do
  let(:keyword) { create(:keyword, content: 'content', status: 2, total_link: 3, total_result: 2, total_ad: 4) }
  before(:each) do
    assign(:keyword, keyword)
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(/content/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/4/)
  end
end
