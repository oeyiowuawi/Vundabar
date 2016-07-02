require "spec_helper"

RSpec.describe "Associations" do
  describe "associations" do
    after(:all) do
      Todo.destroy_all
      Item.destroy_all
    end
    context "has_many associations" do
      it "returns all records belonging to the current object" do
        todo = Todo.create(attributes_for(:todo))
        item = create(:item, title: "associations", todo_id: todo.id)
        expect(todo.items[0].title).to eq item.title
      end
    end

    context "belongs_to associations" do
      it "returns parent object of the current object" do
        todo = Todo.create(attributes_for(:todo))
        item = create(:item, todo_id: todo.id)
        expect(item.todo.title).to eq todo.title
      end
    end
  end
end
