TodoApplication.routes.draw do
  # post "/lekan/:id/yes", to: "todolist#show"
  # get "/todo/:id/edit", to: "todo#create"
  # get "/todolist", to: "todolist#index"
  # get "/todolist/:id", to: "todolist#show"
  # get "/name/about", to: "todolist#lekan"
  root "todolist#index"
  resources :todolist
end
