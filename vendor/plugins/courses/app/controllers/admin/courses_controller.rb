class Admin::CoursesController < Admin::BaseController

  crudify :course, :title_attribute => :title

end
