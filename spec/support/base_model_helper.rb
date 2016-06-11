class TestModel < Vundabar::Basemodel
to_table :tests

property :name, type: :varchar, nullable: false
property :age, type: :integer, default: 21
end
