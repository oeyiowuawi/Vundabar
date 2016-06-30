require "spec_helper"
RSpec.describe Vundabar::BaseModel do
  describe ".all" do
    context "when the database is not empty" do
      before(:all) do
        Todo.destroy_all
        create_list(:todo, 4)
      end

      after(:all) do
        Todo.destroy_all
      end

      it "returns all the records in the database" do
        expect(Todo.all.count).to eq 4
      end

      it "returns result of type array" do
        expect(Todo.all).to be_an Array
      end

      it "returns an instance of the Todo class" do
        expect(Todo.all[0]).to be_an_instance_of Todo
        expect(Todo.all[-1]).to be_an_instance_of Todo
      end
    end

    context "when the database is empty" do
      it "returns an empty array" do
        expect(Todo.all.empty?).to eq true
      end
    end
  end

  describe ".create" do
    after(:all) do
      Todo.destroy_all
    end

    it "increases the count of the records in the database" do
      expect do
        Todo.create(attributes_for(:todo))
      end.to change(Todo, :count).by 1
    end

    it "returns the newly created object" do
      object = Todo.create(
        title: "Steph Curry",
        body: "body",
        status: "done",
        created_at: Time.now.to_s
      )
      expect(object).to be_an_instance_of Todo
    end
  end

  describe ".count" do
    it "returns the correct number of records in a database" do
      create_list(:todo, 2)
      expect(Todo.count).to eq 2
      Todo.destroy_all
    end
  end

  describe ".find" do
    after(:all) do
      Todo.destroy_all
    end

    context "when an id that belongs to a record is supplied" do
      it "returns the record that has the id " do
        object = Todo.create(attributes_for(:todo))
        expect(Todo.find(Todo.last.id).id).to eq object.id
      end
    end

    context "when an id that has no record is supplied" do
      it "returns nil " do
        invalid_id = Todo.last.id + 1
        expect(Todo.find(invalid_id)).to eq nil
      end
    end
  end

  describe ".last" do
    after(:all) do
      Todo.destroy_all
    end

    context "when the database table is empty" do
      it "returns nil" do
        expect(Todo.last).to eq nil
      end
    end

    context "when database table is not empty" do
      it "returns the last record" do
        create_list(:todo, 2)
        last_record = create(:todo, title: "Checkout")
        expect(Todo.last.title).to eq last_record.title
      end
    end
  end

  describe ".first" do
    after(:all) do
      Todo.destroy_all
    end

    context "when the database table is empty" do
      it "returns nil" do
        expect(Todo.first).to eq nil
      end
    end

    context "when database table is not empty" do
      it "returns the first record" do
        first_record = create(:todo, title: "git")
        create_list(:todo, 2)
        expect(Todo.first.title).to eq first_record.title
      end
    end
  end

  describe ".destroy" do
    it "deletes the record from the table" do
      todo = create(:todo)
      Todo.destroy(todo.id)
      expect(Todo.find(todo.id)).to eq nil
    end
  end

  describe ".destroy_all" do
    it "deletes all the rows in the database and returns a count of 0" do
      create_list(:todo, 3)
      Todo.destroy_all
      expect(Todo.count).to eq 0
    end
  end

  describe "#destroy" do
    it "reduces the count of the database by 1" do
      todo = Todo.create(attributes_for(:todo))
      expect do
        todo.destroy
      end.to change(Todo, :count).by(-1)
    end
  end

  describe "#update" do
    before(:all) do
      @todo = Todo.create(attributes_for(:todo))
    end

    after(:all) do
      Todo.destroy_all
    end

    it "doesn't change the count of the records in the database" do
      expect do
        @todo.update(title: "Changed")
      end.to change(Todo, :count).by 0
    end

    it "updates the row" do
      @todo.update(body: "barbosa")
      expect(Todo.find(@todo.id).body).to eq "barbosa"
    end
  end

  describe "#save" do
    after(:all) do
      Todo.destroy_all
    end

    context "when the record has no id " do
      it "increases the number of records in the database" do
        new_record = Todo.new(attributes_for(:todo))
        expect do
          new_record.save
        end.to change(Todo, :count).by 1
      end
    end

    context "when the record has an id already" do
      before(:all) do
        @new_record = Todo.create(attributes_for(:todo))
      end

      it " doesn't change the count of the records in the database" do
        @new_record.title = "test"
        expect do
          @new_record.save
        end.to change(Todo, :count).by 0
      end

      it "updates the record" do
        @new_record.body = "unit testing"
        @new_record.save
        expect(@new_record.body).to eq "unit testing"
      end
    end
  end

  describe ".where" do
    after(:all) do
      Todo.destroy_all
    end

    it "returns matching records" do
      pending_task = create(:todo, title: "iniesta")
      create(:todo, title: "Sergio")
      expect(Todo.where("title like ?", "%iniesta").first.title).to eq(
        pending_task.title
      )
    end
  end
end
