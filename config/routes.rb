Rails.application.routes.draw do

  root to: 'welcome#index'

  get '/states' => 'states#index'
  get '/states/:id' => 'states#show'

  get '/beers/:beerId' => 'beers#show_beer'
  get '/beers/ranked/:beerId' => 'beers#check_ranked_beer'
  put '/beers/vote/:beerId' => 'beers#increment_vote'
  get '/beers/state/:stateId' => 'beers#show_top_beers'

  get '/brewerydb/state/:state' => 'brewerydb#state_breweries'
  get '/brewerydb/city/:city' => 'brewerydb#city_breweries'
  get '/brewerydb/state/:state/beers' => 'brewerydb#state_beers'
  get '/brewerydb/city/:city/beers' => 'brewerydb#city_beers'
  post '/brewerydb/:beerId' => 'brewerydb#create_voted_beer'


end
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
