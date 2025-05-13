class HashCast::Casters::StringCaster
  NULL_BYTE_CHARACTER = "\u0000".freeze

  def self.cast(value, attr_name, options = {})
    casted_value = cast_string(value, attr_name, options)

    if HashCast.config.validate_string_null_byte && casted_value.match?(NULL_BYTE_CHARACTER)
      raise HashCast::Errors::CastingError, 'contains invalid characters'
    end

    if HashCast.config.string_size_validator_enabled
      if value.size > HashCast.config.string_size_validator_limit
        HashCast.config.string_size_validator_callback.call(value, attr_name, options)
      end
    end

    casted_value
  end

  private

  def self.cast_string(value, attr_name, options = {})
    if value.is_a?(String)
      value
    elsif value.is_a?(Symbol)
      value.to_s
    else
      raise HashCast::Errors::CastingError, "should be a string"
    end
  end

end
