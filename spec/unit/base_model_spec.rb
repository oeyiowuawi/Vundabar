require "spec_helper"
RSpec.describe Vundabar::BaseModel do
  describe ".all" do
    context "when the database is not empty" do
      before(:all) do
        create_seed 4
      end

      after(:all) do
        TestModel.destroy_all
      end

      it "returns all the records in the database" do
        expect(TestModel.all.count).to eq 4
      end

      it "returns an array" do
        expect(TestModel.all).to be_an Array
      end

      it "returns objects as elements of the array" do
        expect(TestModel.all[0]).to be_an_instance_of TestModel
        expect(TestModel.all[-1]).to be_an_instance_of TestModel
      end
    end

    context "when the database is empty" do
      it "returns an empty array" do
        expect(TestModel.all.empty?).to eq true
      end
    end
  end

  describe ".create" do
    after(:all) do
      TestModel.destroy_all
    end
    it "saves to the database" do
      expect do
        TestModel.create(name: "leandro Barbosa", age: "45")
      end.to change(TestModel, :count).by 1
    end

    it "returns the newly created object" do
      object = TestModel.create(name: "Steph Curry", age: "27")
      expect(object.name).to eq "Steph Curry"
      expect(object.age).to eq "27"
    end
  end

  describe ".count" do
    after(:all) do
      TestModel.destroy_all
    end
    it "returns the correct number of records in a database" do
      create_seed 2
      expect(TestModel.count).to eq 2
    end
  end

  describe ".find" do
    after(:all) do
      TestModel.destroy_all
    end

    it "returns object when an id that has a record is entered" do
      object = TestModel.create(name: "Clay Thompson", age: "25")
      expect(TestModel.find(object.id).name).to eq object.name
    end

    it "returns nil when an id with no record is entered" do
      invalid_id = TestModel.last.id + 1
      expect(TestModel.find(invalid_id)).to eq nil
    end
  end

  describe ".last" do
    after(:all) do
      TestModel.destroy_all
    end

    context "when the database table is empty" do
      it "returns nil if the table is empty" do
        expect(TestModel.last).to eq nil
      end
    end

    context "when database table is not empty" do
      it "returns the last record of the table" do
        create_seed 2
        object = TestModel.create(name: "Clay Thompson", age: "25")
        expect(TestModel.last.name).to eq object.name
        expect(TestModel.last.age.to_s).to eq object.age
      end
    end
  end

  describe ".first" do
    after(:all) do
      TestModel.destroy_all
    end

    context "when the database table is empty" do
      it "returns nil if the table is empty" do
        expect(TestModel.first).to eq nil
      end
    end

    context "when database table is not empty" do
      it "returns the last record of the table" do
        object = TestModel.create(name: "Clay Thompson", age: "25")
        create_seed 2
        expect(TestModel.first.name).to eq object.name
        expect(TestModel.first.age.to_s).to eq object.age
      end
    end
  end

  describe ".destroy" do
    it "deletes the record from the table" do
      object = TestModel.create(name: "Livingston", age: "25")
      TestModel.destroy(object.id)
      expect(TestModel.find(object.id)).to eq nil
    end
  end

  describe ".destroy_all" do
    it "deletes every record in the database" do
      create_seed 5
      TestModel.destroy_all
      expect(TestModel.count).to eq 0
    end
  end

  describe "#destroy" do
    it "deletes the object from the database" do
      object = TestModel.create(name: "Livingston", age: "25")
      expect do
        object.destroy
      end.to change(TestModel, :count).by -1
    end
  end

  describe "#update" do
    before(:all) do
      @object = TestModel.create(name: "Livingston", age: "25")
    end
    after(:all) do
      TestModel.destroy_all
    end

    it "doesn't create a new record in the database" do
      expect do
        @object.update(age: "45")
      end.to change(TestModel, :count).by 0
    end

    it "updates the object" do
      @object.update(name: "barbosa")
      expect(TestModel.find(@object.id).name).to eq "barbosa"
    end
  end

  describe "#save" do
    after(:all) do
      TestModel.destroy_all
    end

    context "when the object has no id " do
      it "creates a new record in the database" do
        new_record = TestModel.new(name: "Neymar", age: "25")
        expect do
          new_record.save
        end.to change(TestModel, :count).by 1
      end
    end

    context "when the object has an id already" do
      before(:all) do
        @new_record = TestModel.create(name: "Messi", age: "28")
      end

      it " doesn't create a new record" do
        @new_record.name = "Leonnel Messi"
        expect do
          @new_record.save
        end.to change(TestModel, :count).by 0
      end

      it "updates the object" do
        @new_record.age = "29"
        @new_record.save
        expect(@new_record.age.to_s).to eq "29"
      end
    end
  end
  describe ".where" do
     after(:all) do
       TestModel.destroy_all
     end

     it "returns matching records" do
       pending_task = TestModel.create(name: "Iniesta", age: "32")
       completed_todo = TestModel.create(name: "Sergio", age: "27")
       expect(TestModel.where("name like ?", "%iniesta").first.name).to eq(
         pending_task.name
       )

     end
   end
end
