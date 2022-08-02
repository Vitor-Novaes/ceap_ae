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
    query_map_builder
    records_query_scope(records_query_term)
  end

  def records_query_term
    return @source.all if @query_term.empty? || @query_key.empty?

    @source.where(@query_term.join('AND'), @query_key)
  end

  def records_query_scope(records)
    @query_scope.each do |scope|
      return records if records.nil?

      records = records.send(scope, @params)
    end

    records
  end

  def query_map_builder
    @params.each do |key, value|
      search = @source.map_term(key.to_sym)
      scope = @source.map_scope(key.to_sym)

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
end
