Kaminari.configure do |config|
  config.default_per_page = 10
  config.max_per_page = 50
  config.page_method_name = :page
  config.param_name = :page
end
