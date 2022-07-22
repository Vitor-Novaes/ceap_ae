class OrganizationBlueprint < Blueprinter::Base
  identifier :id

  view :summary do
    fields :abbreviation
  end

  view :extended do
    include_view :summary
    association :deputies, blueprint: DeputyBlueprint, view: :summary
  end
end
