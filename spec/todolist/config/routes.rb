TodoApplication.routes.draw do
  root "todolist#index"
  resources :todolist
end
