class TestModel < Vundabar::BaseModel
to_table :tests

property :id, type: :integer, primary_key: true
property :name, type: :varchar, nullable: false
property :age, type: :integer, nullable: false
create_table
end
