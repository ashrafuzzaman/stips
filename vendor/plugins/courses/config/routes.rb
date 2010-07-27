ActionController::Routing::Routes.draw do |map|
  map.resources :courses

  map.namespace(:admin, :path_prefix => 'refinery') do |admin|
    admin.resources :courses, :collection => {:update_positions => :post}
  end
end
