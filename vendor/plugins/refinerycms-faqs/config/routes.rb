ActionController::Routing::Routes.draw do |map|
  map.resources :faqs

  map.namespace(:admin, :path_prefix => 'refinery') do |admin|
    admin.resources :faqs
  end
end
