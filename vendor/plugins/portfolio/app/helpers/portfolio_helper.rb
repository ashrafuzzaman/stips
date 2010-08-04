module PortfolioHelper

  def portfolio_image_link(master, portfolio, image_index)
    if ::Refinery::Portfolio.multi_level?
      portfolio_image_url(master, portfolio, image_index)
    else
      portfolio_image_url(master, image_index)
    end
  end

  def link_to_portfolio_image(master, portfolio, image, index)
    #    link_to(image_fu(image, :portfolio_thumb, :width => 120, :height => (image.height.to_f/image.width * 135)),
    link_to(image_fu(image, :portfolio_thumb, :width => 100, :height => 100),
      portfolio_image_link(master, portfolio, index),
      :class => ((index == params[:image_id].to_i) ? "selected" : "pale"))
  end

end
