class HashCast::Casters::FloatCaster

  def self.cast(value, attr_name, options = {})
    if value.is_a?(Float)
      value
    elsif value.is_a?(String)
      begin
        Float(value)
      rescue ArgumentError => e
        raise HashCast::Errors::CastingError, "is invalid float"
      end
    else
      raise HashCast::Errors::CastingError, "should be a float"
    end
  end

end
