class CoursesController < ApplicationController

  before_filter :find_all_courses
  before_filter :find_page

  def index
    # you can use meta fields from your model instead (e.g. browser_title)
    # by swapping @page for @course in the line below:
    present(@page)
  end

  def show
    @course = Course.find(params[:id])

    # you can use meta fields from your model instead (e.g. browser_title)
    # by swapping @page for @course in the line below:
    present(@page)
  end

protected

  def find_all_courses
    @courses = Course.find(:all, :order => "start_date ASC", :conditions => {:active => true})
  end

  def find_page
    @page = Page.find_by_link_url("/courses")
  end

end
