module ApplicationHelper
  
  def full_title(page_name = "")
    base_title = "AttendanceApp"
    if page_name.empty?  #empty?はあるのが前提
      base_title
    else
      page_name + " | " + base_title
    end
  end
end
