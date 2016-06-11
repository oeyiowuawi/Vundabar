require "spec_helper"

RSpec.descibe BaseModel do
  after(:each) do
    TestModel.destroy_all
  end

  describe ".all" do
    before(:all) do
      create_seed 4
    end

    it "returns all the records in the database" do
      expect(TestModel.all.count).to eq 4
    end

    it "returns an array" do
      expect(TestModel.all).to be_an Array
    end

    it "returns objects as elements of the array" do
      expect(TestModel.all[0]).to be TestModel
      expect(TestModel.all[-1]).to be TestModel
    end
    
  end
end
