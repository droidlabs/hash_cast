class HashCast::Config
  attr_accessor :input_keys, :output_keys, :validate_string_null_byte, 
    :array_size_validator_enabled, :array_size_validator_limit

  DEFAULT_ARRAY_SIZE_VALIDATOR_LIMIT = 1000_000

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
end
