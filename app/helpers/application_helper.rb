module ApplicationHelper
  def display_date(date)
    formatted = date.strftime("%e %b %Y")
  end
  def human_boolean(boolean)
      boolean ? 'Yes' : 'No'
  end
end
