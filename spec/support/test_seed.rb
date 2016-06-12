  def create_seed(n = 1)
    (1..n).each do |i|
      todo = TestModel.new
      todo.name = "name#{i}"
      todo.age = (20..45).to_a.sample
      todo.save
    end
  end
