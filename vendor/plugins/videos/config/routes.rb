ActionController::Routing::Routes.draw do |map|
  map.resources :videos

  map.namespace(:admin, :path_prefix => 'refinery') do |admin|
    admin.resources :videos, :collection => {:update_positions => :post}
  end
end
