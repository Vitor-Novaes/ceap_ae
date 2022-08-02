class OrganizationBlueprint < Blueprinter::Base
  identifier :id

  view :summary do
    fields :abbreviation
  end

  view :extended do
    include_view :summary
    fields :created_at, :updated_at
  end
end
