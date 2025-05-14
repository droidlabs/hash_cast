class HashCast::Config
  attr_writer :input_keys, :output_keys, :validate_string_null_byte, 
    :array_size_validator_enabled, 
    :array_size_validator_limit, 
    :array_size_validator_callback,
    :string_size_validator_enabled, 
    :string_size_validator_limit, 
    :string_size_validator_callback

  DEFAULT_ARRAY_SIZE_VALIDATOR_LIMIT = 1000_000
  DEFAULT_STRING_SIZE_VALIDATOR_LIMIT = 1000_000

  def input_keys
    @input_keys || :symbol
  end

  def output_keys
    @output_keys || :symbol
  end

  def validate_string_null_byte
    return true if @validate_string_null_byte.nil?
    
    @validate_string_null_byte
  end

  def array_size_validator_enabled
    return false if @array_size_validator_enabled.nil?
    
    @array_size_validator_enabled
  end

  def array_size_validator_limit
    return DEFAULT_ARRAY_SIZE_VALIDATOR_LIMIT if @array_size_validator_limit.nil?
    
    @array_size_validator_limit
  end

  def array_size_validator_callback
    if @array_size_validator_callback.nil?
      return lambda{ |value, name, options|
        raise HashCast::Errors::CastingError, "array is too large" 
      }
    end
    
    @array_size_validator_callback
  end

  def string_size_validator_enabled
    return false if @string_size_validator_enabled.nil?
    
    @string_size_validator_enabled
  end

  def string_size_validator_limit
    return DEFAULT_STRING_SIZE_VALIDATOR_LIMIT if @string_size_validator_limit.nil?
    
    @string_size_validator_limit
  end

  def string_size_validator_callback
    if @string_size_validator_callback.nil?
      return lambda{ |value, name, options|
        raise HashCast::Errors::CastingError, "string is too large" 
      }
    end
    
    @string_size_validator_callback
  end
end
