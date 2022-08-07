module Reports
  extend ActiveSupport::Concern

  def report_expenses(records)
    return 0 if records.nil? && records.empty?

    records.pluck(:net_value).sum(&:to_f)
  end
end
