class HashCast::Casters::IntegerCaster

  def self.cast(value, attr_name, options = {})
    if value.is_a?(Integer)
      value
    elsif value.is_a?(String)
      begin
        Integer(value)
      rescue ArgumentError => e
        raise HashCast::Errors::CastingError, "is invalid integer"
      end
    else
      raise HashCast::Errors::CastingError, "should be a integer"
    end
  end

end
