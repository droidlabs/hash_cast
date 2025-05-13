class HashCast::Casters::ArrayCaster

  def self.cast(value, attr_name, options = {})
    unless value.is_a?(Array)
      raise HashCast::Errors::CastingError, "should be an array"
    end

    if HashCast.config.array_size_validator_enabled
      if value.size > HashCast.config.array_size_validator_limit
        raise HashCast::Errors::CastingError, "array is too large"
      end
    end

    if options[:each]
      cast_array_items(value, attr_name, options)
    else
      value
    end
  end

  private

  def self.cast_array_items(array, attr_name, options)
    caster_name = options[:each]
    caster = HashCast.casters[caster_name]
    check_caster_exists!(caster, caster_name)
    array.map do |item|
      caster.cast(item, "#{attr_name} item", options)
    end
  end

  def self.check_caster_exists!(caster, caster_name)
    unless caster
      raise HashCast::Errors::CasterNotFoundError, "caster with name #{caster_name} is not found"
    end
  end

end
