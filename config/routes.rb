Sodexo::Application.routes.draw do

  root "restaurants#index"  

  get "reports/index" => "reports#index", as: :report_index
  post "reports/result" => "reports#result", as: :report_result
  post "reports/result_per_month" => "reports#result_per_month", as: :report_result_per_month
  post "reports/check_survey_availability" => "reports#check_survey_availability", as: :report_check_survey_availability
  get "restaurants/choose_restaurant" => "restaurants#choose_restaurant", as: :choose_restaurant
  post "restaurants/survey_of_today" => "restaurants#survey_of_today", as: :survey_of_today
  post "restaurants/survey_result" => "restaurants#survey_result", as: :survey_result
  resources :restaurants
  resources :questions
  resources :categories
  resources :sub_categories
  resources :surveys
  resources :choosen_questions
  resources :answers
  resources :alternatives
  resources :availabilities
  resources :user_types
  post "user/session_for_mobile" => "user#session_for_mobile", as: :session_for_mobile
  devise_for :users, controllers: {registrations: "users/registrations", sessions: "users/sessions"}

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end
  
  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
