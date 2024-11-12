class HashCast::Config
  attr_accessor :input_keys, :output_keys, :validate_string_null_byte

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
end
