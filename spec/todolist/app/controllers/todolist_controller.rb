class TodolistController < Vundabar::BaseController

  def index
    @pendings = Todo.where("status like ?", "%pending%")
    @completed = Todo.where("status like ?", "%done%")
  end

  def show
    @todo = Todo.find(params["id"])
  end

  def delete
    todo = Todo.find(params["id"])
    todo.destroy
    redirect_to "/todolist"
  end

  def update
    todo = Todo.find(params["id"])
    todo.update(required_params)
    redirect_to "/todolist/#{todo.id}"
  end

  def new
  end

  def create
    binding.pry
    todo = Todo.create(required_params)
    redirect_to "/todolist/#{todo.id}"
  end

  def edit
    @todo = Todo.find(params["id"])
  end

  private

  def required_params
    {
      title: params["title"],
      body: params["body"],
      status: params["status"],
      created_at: Time.now.to_s
    }

  end
end
