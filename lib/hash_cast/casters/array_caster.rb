class HashCast::Casters::ArrayCaster

  def self.cast(value, attr_name, options = {})
    if value.is_a?(Array)
      if options[:each]
        cast_array_items(value, attr_name, options)
      else
        value
      end
    else
      raise HashCast::Errors::CastingError, "should be an array"
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
