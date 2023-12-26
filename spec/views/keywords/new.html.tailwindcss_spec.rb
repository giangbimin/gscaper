require 'rails_helper'

RSpec.describe 'keywords/new', type: :view do
  it 'renders new keyword form' do
    render

    assert_select 'form[action=?][method=?]', keywords_path, 'post' do
      assert_select 'input[name=?]', 'keywords[file]'
    end
  end
end
