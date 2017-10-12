class Api::V1::ReportsController < Api::V1::ApplicationController
  before_action :require_login

  # GET /by_author
  def by_author
    GenerateReportJob.perform_later report_params.to_hash
    render json: { message: 'Report generation started' }
  end

  private

    def report_params
      params.permit(
        :start_date,
        :end_date,
        :email
      )
    end
end
