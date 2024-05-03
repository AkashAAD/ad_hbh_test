Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :transactions, only: [] do
        collection do
          post :order
          post :return
        end
      end
    end
  end
end
