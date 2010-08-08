class PollsController < ApplicationController

  before_filter :find_all_polls
  before_filter :find_page

  def index
    present(@page)
  end

  def show
    @poll = Poll.find(params[:id])
    present(@page)
  end

  def submit
    @poll = Poll.find(params[:id])
    poll_answer_id = params[:poll_answer_id]
    if poll_answer_id.nil?
      flash[:notice] = "No answer selected"
    else
      poll_answer = PollAnswer.find(poll_answer_id)
      poll_answer.vote += 1
      poll_answer.save
      UsersPoll.create(:user_identifier => request.ip, :poll_answer_id => poll_answer_id, :poll_id => params[:id])
      session[:recent_poll_id] = @poll.id
    end
    redirect_to :back
  end

  protected

  def find_all_polls
    @polls = Poll.find(:all, :order => "position ASC")
  end

  def find_page
    @page = Page.find_by_link_url("/polls")
  end

end
