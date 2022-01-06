class QueryFilter
  DEFAULT_LIMIT = 10

  def initialize(base_table, options, mapping)
    @base_table = base_table
    @query = base_table.to_s.capitalize.constantize
    @options = options
    @mapping = mapping
  end

  def query
    @mapping.each do |field, query_params|
      filter_field(query_params, @options[field])
    end

    @query.limit(limit).offset(page * limit)
  end

  private

  def filter_field(query_params, value)
    return unless value.present?

    field, query = resolve_complex(query_params, @query)

    @query = query.where("#{field} LIKE ?", "%#{value}%")
  end

  def resolve_complex(query_params, query)
    query_params = query_params.split('.')

    # Add base table name if none provided
    query_params.unshift(@base_table) if query_params.length == 1

    table_name = query_params[0]
    field_name = query_params[1]

    # Join with table if its not the base table
    query = query.joins(table_name.to_sym) if table_name != @base_table

    ["#{table_name.to_s.pluralize}.#{field_name}", query]
  end

  def limit
    @limit ||= Integer(@options[:limit]) rescue DEFAULT_LIMIT
  end

  def page
    @page ||= Integer(@options[:page]) rescue 0
  end
end
