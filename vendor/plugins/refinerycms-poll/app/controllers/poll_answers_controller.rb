class PollAnswersController < ApplicationController

  before_filter :find_all_poll_answers
  before_filter :find_page

  def index
    # you can use meta fields from your model instead (e.g. browser_title)
    # by swapping @page for @poll_answer in the line below:
    present(@page)
  end

  def show
    @poll_answer = PollAnswer.find(params[:id])

    # you can use meta fields from your model instead (e.g. browser_title)
    # by swapping @page for @poll_answer in the line below:
    present(@page)
  end

protected

  def find_all_poll_answers
    @poll_answers = PollAnswer.find(:all, :order => "position ASC")
  end

  def find_page
    @page = Page.find_by_link_url("/poll_answers")
  end

end
