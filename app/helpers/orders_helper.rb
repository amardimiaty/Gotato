module OrdersHelper
  
  def sortable(column, title = nil)
    title ||= column.capitalize
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to title, params.merge!(:sort => column, :direction => direction, :authenticity_token => nil), {:class => "sort-header", :method => :get}
  end

  def arrow(column)
    if params[:direction] == "asc"
      raw("<span class='glyphicon glyphicon-sort-by-order-alt  sort' aria-hidden='true'></span>")
    elsif params[:direction] == "desc"
      raw("<span class='glyphicon glyphicon-sort-by-order sort' aria-hidden='true'></span>")
    else
      raw("<span class='glyphicon glyphicon-sort sort' aria-hidden='true'></span>")
    end
  end

  def sort_column
    Order.column_names.include?(params[:sort]) ? params[:sort] : "id"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end

  def receive_check(status)
    if status == true
      "YES"
    else
      ""
    end
  end

  def store_location
    session[:saved_url] = request.referer  #Store location of the previous request
  end

  def redirect_back_or(default, controller, action)
    if controller == "orders" && action == "show"
      redirect_to(default)  #Return to default views when delete from a show action
    elsif controller == "shippings" && action == "show"
      redirect_to(default)
    else
      redirect_to(session[:saved_url] || default)
    end
    session.delete(:saved_url)
  end


end
