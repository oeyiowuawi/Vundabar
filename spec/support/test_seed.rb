  def create_seed(n = 1, status = "done")
    (1..n).each do |i|
      todo = Todo.new
      todo.title = Faker::Lorem.word
      todo.body = Faker::Lorem.sentence
      todo.status = status
      todo.save
    end
  end
