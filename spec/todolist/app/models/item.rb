class Item < Vundabar::BaseModel
  to_table :items
  property :id, type: :integer, primary_key: true
  property :todo_id, type: :integer
  property :title, type: :text, nullable: false
  create_table

  belongs_to :todo
end
