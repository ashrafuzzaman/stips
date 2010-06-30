class Admin::PollsController < Admin::BaseController

  crudify :poll, :title_attribute => :title

end
