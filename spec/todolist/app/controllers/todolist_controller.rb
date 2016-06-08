class TodolistController < Vundabar::BaseController
  def get
    "['Write a book', 'Build a house', 'Get married', 'Buy a car']"
  end

  def get_first
    "Write a book"
  end

  def post
    "Post go swimming"
  end

  def put
    "Put Write a book"
  end

  def delete
    "Delete Write a book"
  end

  def lekan
    lekan = Todo.new
    lekan.title = "dope boy"
    lekan.body = "a rare gem, no puns intended"
    lekan.status = "done"
    lekan.created_at = Time.now.to_s
    lekan.save
    @name = "Adebare"
  end
end
