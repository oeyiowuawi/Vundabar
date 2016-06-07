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
    @name = "Adebare"
  end
end
