require "./config/application.rb"
TodoApplication = Todolist::Application.new

TodoApplication.routes.draw do

  post '/lekan/:id/yes', to: "todolist#show"
  get "/todo/:id/edit", to: "todo#create"
  get '/todolist', to: "todolist#index"
  get '/todolist/:id', to: "todolist#show"
  get '/rubular/:id', to: "todolist#show"

end

run TodoApplication
