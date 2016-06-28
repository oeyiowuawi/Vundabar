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

      it "returns an array" do
        expect(Todo.all).to be_an Array
      end

      it "returns objects as elements of the array" do
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
    it "saves to the database" do
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
      expect(object.title).to eq "Steph Curry"
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

    it "returns object when an id that has a record is entered" do
      object = create(:todo)
      expect(Todo.find(Todo.last.id).title).to eq object.title
    end

    it "returns nil when an id with no record is entered" do
      invalid_id = Todo.last.id + 1
      expect(Todo.find(invalid_id)).to eq nil
    end
  end

  describe ".last" do
    after(:all) do
      Todo.destroy_all
    end

    context "when the database table is empty" do
      it "returns nil if the table is empty" do
        expect(Todo.last).to eq nil
      end
    end

    context "when database table is not empty" do
      it "returns the last record of the table" do
        create_list(:todo, 2)
        object = create(:todo, title: "Checkout")
        expect(Todo.last.title).to eq object.title
      end
    end
  end

  describe ".first" do
    after(:all) do
      Todo.destroy_all
    end

    context "when the database table is empty" do
      it "returns nil if the table is empty" do
        expect(Todo.first).to eq nil
      end
    end

    context "when database table is not empty" do
      it "returns the last record of the table" do
        object = create(:todo, title: "git")
        create_list(:todo, 2)
        expect(Todo.first.title).to eq object.title
      end
    end
  end

  describe ".destroy" do
    it "deletes the record from the table" do
      object = create(:todo)
      Todo.destroy(object.id)
      expect(Todo.find(object.id)).to eq nil
    end
  end

  describe ".destroy_all" do
    it "deletes every record in the database" do
      create_list(:todo, 3)
      Todo.destroy_all
      expect(Todo.count).to eq 0
    end
  end

  describe "#destroy" do
    it "deletes the object from the database" do
      object = Todo.create(attributes_for(:todo))
      expect do
        object.destroy
      end.to change(Todo, :count).by(-1)
    end
  end

  describe "#update" do
    before(:all) do
      @object = Todo.create(attributes_for(:todo))
    end
    after(:all) do
      Todo.destroy_all
    end

    it "doesn't create a new record in the database" do
      expect do
        @object.update(title: "Changed")
      end.to change(Todo, :count).by 0
    end

    it "updates the object" do
      @object.update(body: "barbosa")
      expect(Todo.find(@object.id).body).to eq "barbosa"
    end
  end

  describe "#save" do
    after(:all) do
      Todo.destroy_all
    end

    context "when the object has no id " do
      it "creates a new record in the database" do
        new_record = Todo.new(attributes_for(:todo))
        expect do
          new_record.save
        end.to change(Todo, :count).by 1
      end
    end

    context "when the object has an id already" do
      before(:all) do
        @new_record = Todo.create(attributes_for(:todo))
      end

      it " doesn't create a new record" do
        @new_record.title = "test"
        expect do
          @new_record.save
        end.to change(Todo, :count).by 0
      end

      it "updates the object" do
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
