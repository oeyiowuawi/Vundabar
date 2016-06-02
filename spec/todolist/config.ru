require "./config/application.rb"
TodoApplication = Todolist::Application.new

TodoApplication.routes.draw do

  get '/todolist', to: "todolist#index"
end

run TodoApplication
