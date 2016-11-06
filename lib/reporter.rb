class Reporter
  def initialize(months)
    @output_months = months
  end

  def write_html(file_name)
    html = ''

    @output_months.each { |m| html << html_for_month(m) }

    html << "<hr>Generated #{DateTime.now}"
    File.write(file_name, html)
  end

  private def html_for_month(month)
    html = "<table border=2 cellpadding=10>\n"

    html << "<tr><th colspan=7>Month of #{month.date}\n"

    html << "<tr><th>Checking before<td>Income<td>Expenses<td>Net<th>Checking after bills"
    html << "<td>Saving total<th>Checking final, after saving\n"
    html << "<tr align=right><td>#{pretty_num(month.checking_before)}"
    html << "<td>#{pretty_num(month.income)}"
    html << "<td>#{pretty_num(month.expenses)}"
    html << "<td>#{pretty_num(month.net)}"

    if month.checking_after < 0.0
      html << "<td bgcolor=red style='color:white'>"
    else
      html << "<td>"
    end
    html << "#{pretty_num(month.checking_after)}"
    html << "<td>#{pretty_num(month.move_to_savings)}"
    if month.checking_final < 0.0
      html << "<td bgcolor=red style='color:white'>"
    else
      html << "<td>"
    end
    html << "#{pretty_num(month.checking_final)}\n"

    html << "<tr><td colspan=4><th>Savings before<td>Saving total<th>Savings after\n"
    html << "<tr align=right><td colspan=4>"
    html << "<td>#{pretty_num(month.saving_before)}"
    html << "<td>#{pretty_num(month.savings_net)}"
    html << "<td>#{pretty_num(month.saving_after)}\n"

    html << "<tr><td colspan=7>\n"
    html << "Salary events/changes:\n<ul>\n"
    month.salary_events.each do |e|
      html << "<li>#{e}\n"
    end
    html << "</ul>\n"
    html << "Bills events/changes:\n<ul>\n"
    month.bills_events.each do |e|
      html << "<li>#{e}\n"
    end
    html << "</ul>\n"
    html << "Extra events:\n<ul>\n"
    month.extra_events.each do |e|
      html << "<li>#{e}\n"
    end
    html << "</ul>\n"
    html << "Save-Spending events:\n<ul>\n"
    month.save_spend_events.each do |e|
      html << "<li>#{e}\n"
    end
    html << "</ul>\n"

    html << "</table><br>\n"

    html
  end

  private def pretty_num(number)
    "$ #{'%.2f' % number}"
  end
end
