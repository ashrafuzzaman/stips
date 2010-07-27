class Admin::VideosController < Admin::BaseController

  crudify :video, :title_attribute => :title

end
