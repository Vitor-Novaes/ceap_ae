module FilterSource
  extend ActiveSupport::Concern

  def filter_source(source, params = {})
    @source = source
    @params = params
    @query_key = {}
    @query_scope_key = {}
    @query_term = []
    @query_scope = []

    query_execute
  end

  private

  def query_execute
    sql_map_builder
    builder_query_scope(builder_query_term)
  end

  def builder_query_term
    return @source.all if @query_term.empty? || @query_key.empty?

    @source.where(@query_term.join('AND'), @query_key)
  end

  def builder_query_scope(records)
    @query_scope.each do |scope|
      return records if records.nil?

      records = records.send(scope, @params)
    end

    records
  end

  def sql_map_builder
    @params.each do |key, value|
      search = self.send("map_term_#{@source.name.downcase}", key.to_sym)
      scope = self.send("map_scope_#{@source.name.downcase}", key.to_sym)

      unless search.nil?
        value = "%#{@source.sanitize_sql_like(value)}%" if search[:type] == 'string'
        @query_term << search[:term]
        @query_key.store(key.to_sym, value)
      end

      unless scope.nil?
        @query_scope << scope
        @query_scope_key.store(key.to_sym, value)
      end
    end
  end

  def map_term_deputy(key)
    {
      name: { term: ' name ILIKE :name ', type: 'string' },
      ide: { term: ' ide = :ide ', type: 'number' },
      parlamentary_card: { term: ' parlamentary_card = :parlamentary_card ', type: 'number' },
      cpf: { term: ' cpf LIKE :cpf ', type: 'string' }
    }[key]
  end

  def map_scope_deputy(key)
    {
      organization: 'by_organization',
      total_spent: 'sort_spent'
    }[key]
  end
end
