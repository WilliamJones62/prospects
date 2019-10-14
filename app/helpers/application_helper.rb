module ApplicationHelper

  def display_date(date)
    if date
      formatted = date.strftime("%Y %m %d")
    else
      formatted = ' '
    end
  end

  def first_call(prospect)
    p = Prospect.find(prospect)
    if p.prospect_calls.length > 0
      c = p.prospect_calls.first
      if c.call_date
        formatted = c.call_date.strftime("%Y %m %d")
      else
        formatted = ' '
      end
    else
      formatted = ' '
    end
  end

  def second_call(prospect)
    p = Prospect.find(prospect)
    if p.prospect_calls.length > 1
      c = p.prospect_calls.second
      if c.call_date
        formatted = c.call_date.strftime("%Y %m %d")
      else
        formatted = ' '
      end
    else
      formatted = ' '
    end
  end

  def third_call(prospect)
    p = Prospect.find(prospect)
    if p.prospect_calls.length > 2
      c = p.prospect_calls.third
      if c.call_date
        formatted = c.call_date.strftime("%Y %m %d")
      else
        formatted = ' '
      end
    else
      formatted = ' '
    end
  end

  def last_call(prospect)
    p = Prospect.find(prospect)
    if p.prospect_calls.length > 0
      c = p.prospect_calls.last
      if c.call_date
        formatted = c.call_date.strftime("%Y %m %d")
      else
        formatted = ' '
      end
    else
      formatted = ' '
    end
  end

  def city_state(prospect)
    if prospect.city.blank? || prospect.state.blank?
      formatted = ' '
    else
      formatted = prospect.city + ', ' + prospect.state
    end
  end

  def days_active(date)
    if date.blank?
      days = ' '
    else
      days = (Date.today - date.to_date).to_i
    end
  end

  def human_boolean(boolean)
      boolean ? 'Yes' : 'No'
  end

end
