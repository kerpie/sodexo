Sodexo::Application.routes.draw do

  root "reports#index"  

  get "reports/index" => "reports#index", as: :report_index
  post "reports/result" => "reports#result", as: :report_result

  get "reports/range" => "reports#report_per_range", as: :report_per_range
  post "reports/result_per_range" => "reports#result_per_range", as: :result_per_range
  
  get "reports/report_per_month" => "reports#report_per_month", as: :report_per_month
  post "reports/result_per_month" => "reports#result_per_month", as: :result_per_month
  post "reports/result_per_month_with_year" => "reports#result_per_month_with_year", as: :result_per_month_with_year
  get "reports/report_total" => "reports#report_total", as: :report_total
  post "reports/result_total" => "reports#result_total", as: :result_total
  get "reports/report_detailed_by_service" => "reports#report_detailed_by_service", as: :report_detailed_by_service
  post "reports/result_detailed_by_service" => "reports#result_detailed_by_service", as: :result_detailed_by_service

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

  post "answers/new_create" => "answers#new_create", as: :new_answer_create
  post "answers/save_delayed_answer" => "answers#save_delayed_answer", as: :save_delayed_answer
  resources :answers
  resources :alternatives
  resources :availabilities
  resources :user_types
  post "user/session_for_mobile" => "user#session_for_mobile", as: :session_for_mobile
  post "user/restaurants_for_user" => "user#restaurants_for_user", as: :restaurants_for_user
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
