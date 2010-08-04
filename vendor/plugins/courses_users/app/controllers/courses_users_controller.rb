class CoursesUsersController < ApplicationController
  before_filter :login_required

  def register
    course_user = current_user.courses_users.create(:course_id => params[:course_id], :amount_paid => 100)
    course_user.confirm!
    flash[:notice] = "Successfully registered..."
    redirect_to :back
  end

end