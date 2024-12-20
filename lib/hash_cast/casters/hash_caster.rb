class HashCast::Casters::HashCaster

  def self.cast(value, attr_name, options = {})
    if value.is_a?(Hash)
      value
    else
      raise HashCast::Errors::CastingError, "should be a hash"
    end
  end

end
