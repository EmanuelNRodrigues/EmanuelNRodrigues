Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  resources :users, only: %i[index create show update destroy] do
    resources :projects, only: %i[index create show update destroy] do
      resources :documents, path: 'documents/:document_type',
                            only: %i[index create show update destroy] do
        member { get 'export' }
      end
    end
  end
end
