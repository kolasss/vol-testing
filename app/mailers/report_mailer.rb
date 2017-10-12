class ReportMailer < ApplicationMailer
  def by_author(rows, email, start_date, end_date)
    @rows = rows
    @start_date = start_date
    @end_date = end_date
    mail(to: email, subject: 'Аналитический отчет by_author')
  end
end
