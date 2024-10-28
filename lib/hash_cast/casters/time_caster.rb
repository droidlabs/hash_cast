require 'time'

class HashCast::Casters::TimeCaster

  def self.cast(value, attr_name, options = {})
    if value.is_a?(Time)
      value
    elsif value.is_a?(String)
      begin
        Time.parse(value)
      rescue ArgumentError => e
        raise HashCast::Errors::CastingError, "is invalid time"
      end
    else
      raise HashCast::Errors::CastingError, "should be a time"
    end
  end

end
