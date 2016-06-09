class TodolistController < Vundabar::BaseController
  def get
    "['Write a book', 'Build a house', 'Get married', 'Buy a car']"
  end

  def get_all
  end

  def index
    @todos = Todo.all
  end

  def show
    @todo = Todo.find(params["id"])
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

  def new
    # l = Todo.new({title: "real", body: "meatball", status: "done", created_at: Time.now.to_s})
    l = Todo.new
    l.title = "jamaica"
    l.body = "lovely"
    l.status = "done"
    l.created_at = Time.now.to_s
    l.save
    # lekan.update(title: "Pedro Lopez", body: "Mi casa, su casa", status: "done", created_at: Time.now.to_s)
    @name = "Olalekan"
  end
end
