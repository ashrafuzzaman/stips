class Admin::CoursesUsersController < Admin::BaseController

  crudify :courses_users, :title_attribute => :amount_paid
  before_filter :find_poll, :only => [:new, :create, :update, :destroy, :edit, :show]

  def index
    paginate_all_poll_answers
  end

  protected

  def paginate_all_poll_answers
    @course = Course.find params[:course_id]
    @courses_users = CoursesUser.paginate :page => params[:page],
      :conditions => {:course_id => params[:course_id]}
  end

  def restrict_controller
    false
  end

end
