require "spec_helper"

RSpec.describe "Create Todo", type: :feature do
  # before(:all) do
  #   Todo.destroy_all
  # end

  after(:all) do
    Todo.destroy_all
  end

  scenario "when a user visits the root page" do
    visit "/"
    expect(page).to have_content "Create New Todo"
    expect(page).to have_content "Pending Todos"
    expect(page).to have_content "Completed Todos"

    click_link "Create New Todo"
    expect(page).to have_content "New Task"

    fill_in "title", with: "Andela"
    fill_in "body", with: "The top one percent Company"
    select "Pending", from: "status"
    click_button "Create New Task"

    expect(page).to have_content "Andela"
    expect(page).to have_content "The top one percent Company"
    expect(page).to have_content "pending"
    expect(page).to have_content "Delete"
    expect(page).to have_content "Edit"
  end
end
