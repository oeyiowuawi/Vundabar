require "spec_helper"

RSpec.describe "Update a todo", type: :feature do

  scenario "when updating an existing to" do

    todo = Todo.create(attributes_for(:todo))
    visit "/todolist/#{todo.id}/edit"
    expect(page).to have_content "Update Task"

    title = "Another title"
    body = "Testing update" 

    fill_in "title", with: title
    fill_in "body", with: body
    select "Done", from: "status"
    click_button "update_task"

    expect(page.current_path).to eq "/todolist/#{todo.id}"
    expect(page).to have_content "Status: done"
    expect(page).to have_content body
    expect(page).to have_content title

    Todo.destroy_all
  end
end
