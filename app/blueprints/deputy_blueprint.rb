class DeputyBlueprint < Blueprinter::Base
  identifier :id

  view :summary do
    fields :cpf, :name, :state, :ide, :parlamentary_card
    field :photo_url do |deputy|
      "http://www.camara.leg.br/internet/deputado/bandep/#{deputy.ide}.jpg"
    end

    association :organization, blueprint: OrganizationBlueprint, view: :summary
  end

  view :extended do
    include_view :summary
    field :total_expenditures do |object|
      object.expenditures.sum(:net_value).ceil(2)
    end
  end
end
