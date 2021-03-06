class CoursesUsersController < ApplicationController
  #before_filter :login_required
  before_filter :initiate_courses_user, :only => [:success_callback, :cancel_callback]

  def register
    course = Course.find params[:course_id]
    @course_user = course.courses_users.create(
      :email => params[:email],
      :first_name => params[:first_name],
      :last_name => params[:last_name],
      :amount_paid => course.fee)
    if course.free?
      @course_user.confirm!
      flash[:notice] = "Successfully registered..."
      redirect_to :back
      return
    end

    pay_args = {:sender => {:email => params[:email], :first_name => params[:first_name], :last_name => params[:last_name]},
      :return_url => success_callback_courses_user_url(@course_user),
      :cancel_url => cancel_callback_courses_user_url(@course_user),
      :custom => @course_user.id,
      :memo => "Payment for #{@course_user.course.title}"}
    @payment = Payson.new(course.fee).pay pay_args

    @course_user.update_attribute(:params, {:requested_params => pay_args, :response => @payment.response.params}.to_yaml)

    if @payment.response.success?
      redirect_to @payment.payment_redirection_url
    else
      redirect_to cancel_callback_courses_user_path(@course_user)
    end
  end
  


  def success_callback
    payment_response = Payson.payment_details @payment_transaction.token

    if payment_response.completed?
      @courses_user.confirm!
      flash[:notice] = "Successfully registered..."
    end
    redirect_to_course_page
  end

  def cancel_callback
    @courses_user.fail!
    flash[:notice] = "Coursen registeration failed. Please try later..."
    redirect_to_course_page
  end

  private
  def initiate_courses_user
    @courses_user = CoursesUser.find(params[:custom] || params[:id])
    @courses_user.update_attribute(:token, params[:TOKEN]) if params[:TOKEN].present?
  end

  def redirect_to_course_page
    redirect_to @courses_user.course
  end

end