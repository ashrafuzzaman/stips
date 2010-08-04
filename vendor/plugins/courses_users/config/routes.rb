ActionController::Routing::Routes.draw do |map|
  map.resources :courses_users, :collection => { :register => :post }

  map.namespace(:admin, :path_prefix => 'refinery') do |admin|
    admin.resources :courses_users, :collection => {:update_positions => :post}
  end
end
