class DeputyBlueprint < Blueprinter::Base
  identifier :id

  view :summary do
    fields :cpf, :name, :state, :ide, :parlamentary_card
    # at_least_for_now
    field :total_spent do |object|
      object.expenditures.sum(:net_value).ceil(2)
    end
    field :photo_url do |deputy|
      "http://www.camara.leg.br/internet/deputado/bandep/#{deputy.ide}.jpg"
    end

    association :organization, blueprint: OrganizationBlueprint, view: :summary
  end

  view :extended do
    include_view :summary
    fields :created_at, :updated_at
  end
end
