class HashCast::Casters::IntegerCaster

  DEFAULT_MIN_VALUE = 2**31 * -1
  DEFAULT_MAX_VALUE = 2**31

  def self.cast(value, attr_name, options = {})
    integer_value = get_integer_value(value)

    if integer_value < options.fetch(:min_value, DEFAULT_MIN_VALUE)
      raise HashCast::Errors::CastingError, "should be within allowed range"
    end

    if integer_value > options.fetch(:max_value, DEFAULT_MAX_VALUE)
      raise HashCast::Errors::CastingError, "should be within allowed range"
    end

    integer_value
  end

  private
    def self.get_integer_value(value)
      if value.is_a?(Integer)
        return value
      end

      if value.is_a?(String)
        begin
          return Integer(value)
        rescue ArgumentError => e
          raise HashCast::Errors::CastingError, "is invalid integer"
        end
      end

      raise HashCast::Errors::CastingError, "should be a integer"
    end
end
