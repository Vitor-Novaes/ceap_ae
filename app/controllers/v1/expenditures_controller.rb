module V1
  class ExpendituresController < ApplicationController
    def index
      expenditures = filter_source(Expenditure, params)

      render json: ExpenditureBlueprint.render(
        paginate(expenditures, per_page: params[:per_page], page: params[:page]),
        view: :summary,
        root: :expenditures,
        meta: {
          total_expenses: report_expenses(expenditures)
        }
      ), status: :ok
    end

    # at_least_for_now to_remove
    def import_data
      @file = params[:file]

      if @file.nil? || !['text/csv'].include?(@file.content_type)
        raise ActionController::BadRequest, 'That action require CSV file type'
      end

      path_file = "tmp/uploaded_#{Time.now.to_i}.csv"
      File.open(path_file, 'w') { |f| f.write(@file.read.force_encoding('UTF-8')) }
      ImportDataJob.perform_later(path_file)

      render json: { message: 'Success enqueued process' }, status: :ok
    end

    def show
      render json: ExpenditureBlueprint.render(
        Expenditure.find(params[:id]),
        view: :extended
      ), status: :ok
    end
  end
end
