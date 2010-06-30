class Admin::PollAnswersController < Admin::BaseController

  crudify :poll_answer, :title_attribute => :title
  before_filter :find_poll, :only => [:new, :create, :update, :destroy, :edit, :show]

  def index
    paginate_all_poll_answers
  end
  
  def create
    if (@poll_answer = PollAnswer.create({:poll_id => params[:poll_id]}.merge(params[:poll_answer]))).valid?
      flash.now[:notice] = "#{@poll_answer.title} was successfully created."
      redirect_to admin_poll_poll_answers_url(params[:poll_id])
    else
      render :action => 'new'
    end
  end

  def update
    if @poll_answer.update_attributes({:poll_id => params[:poll_id]}.merge(params[:poll_answer]))
      flash.now[:notice] = "#{@poll_answer.title} was successfully updated."
      redirect_to admin_poll_poll_answers_url(params[:poll_id])
    else
      render :action => 'edit'
    end
  end

  def find_poll
    @poll = Poll.find(params[:poll_id])
  end

  def restrict_controller
    false
  end

  def paginate_all_poll_answers
    @poll_answers = PollAnswer.paginate :page => params[:page],
      :conditions => {:poll_id => params[:poll_id]}
  end

end
