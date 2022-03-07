Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "applications#index"

  get "/applications/:application_id/chats/:chat_id/messages/search", to: "messages#search_messages"

  resources :applications do
    resources :chats do
      resources :messages
    end
  end

end
