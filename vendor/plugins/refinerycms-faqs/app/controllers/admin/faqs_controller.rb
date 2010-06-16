class Admin::FaqsController < Admin::BaseController

  crudify :faq, :title_attribute => :title,
    :order => "position ASC",
    :sortable => true

end
