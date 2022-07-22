class ExpenditureBlueprint < Blueprinter::Base
  identifier :id

  view :summary do
    fields :provider, :date, :period, :net_value
    association :category, blueprint: CategoryBlueprint
    association :deputy, blueprint: DeputyBlueprint, view: :summary
  end

  view :extended do
    include_view :summary
    fields :receipt_url, :receipt_type, :provider_documentation, :created_at, :updated_at
  end
end
