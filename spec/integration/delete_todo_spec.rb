require "spec_helper"

RSpec.describe "Delete Todo", type: :feature do

  scenario "when deleting a todo" do
    Todo.destroy_all
    create_list(:todo, 2)
    todo = create(:todo, title: "Test")
    visit "/"

    within("div#pending-todo") do
      expect(page).to have_css("li", count: 3)
    end
    page.all(".delete")[-1].click

    within("div#pending-todo") do
      expect(page).to have_css("li", count: 2)
    end
    expect(page).to have_no_content("Test")
    Todo.destroy_all
  end
end
