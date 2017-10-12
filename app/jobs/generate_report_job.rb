class GenerateReportJob < ApplicationJob
  queue_as :default

  rescue_from(StandardError) do |exception|
    return
  end

  def perform(params)
    start_date = Time.parse params['start_date']
    end_date = Time.parse params['end_date']
    rows = ReportDataAggregator.new(start_date, end_date).sorted_data
    ReportMailer.by_author(
      rows,
      params['email'],
      start_date,
      end_date
    ).deliver_now
  end
end
