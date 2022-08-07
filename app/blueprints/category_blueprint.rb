class CategoryBlueprint < Blueprinter::Base
  identifier :id

  view :summary do
    fields :name
  end

  view :extended do
    include_view :summary
    # at_least_for_now
    field :total_spent do |object|
      object.expenditures.sum(:net_value).ceil(2)
    end
  end
end
