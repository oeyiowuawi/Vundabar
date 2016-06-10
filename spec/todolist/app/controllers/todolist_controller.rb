class TodolistController < Vundabar::BaseController

  def index
    @todos = Todo.all
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
      status: params["done"],
      created_at: Time.now.to_s
    }

  end
end
