class HashCast::RecursiveCasterApplicator
  attr_reader :attributes, :options

  def initialize(attributes, options)
    @attributes         = attributes
    @options            = options
  end

  def cast(input_hash, opts = {})
    casted_hash = {}

    hash_keys = get_keys(input_hash)
    attributes.each do |attribute|
      if hash_keys.include?(attribute.name)
        begin
          casted_value = cast_attribute(attribute, input_hash)
          casted_hash[attribute.name] = casted_value
        rescue HashCast::Errors::AttributeError => e
          handle_attribute_error(e, attribute)
        end
      else
        raise HashCast::Errors::MissingAttributeError.new("should be given", attribute.name) if attribute.required?
      end
    end

    if options.has_key?(:skip_unexpected_attributes) && !options[:skip_unexpected_attributes]
      check_unexpected_attributes_not_given!(hash_keys, casted_hash.keys)
    end

    casted_hash
  end

  private

  def handle_attribute_error(exception, attribute)
    exception.add_namespace(attribute.name)
    raise exception
  end

  def cast_attribute(attribute, hash)
    value = get_value(hash, attribute.name)
    if value.nil? && attribute.allow_nil?
      nil
    else
      casted_value = attribute.caster.cast(value, attribute.name, attribute.options)
      if attribute.has_children?
        cast_children(casted_value, attribute)
      elsif caster = attribute.options[:caster]
        cast_children_with_caster(casted_value, attribute, caster)
      else
        casted_value
      end
    end
  end

  def cast_children(value, attribute)
    caster = self.class.new(attribute.children, options)
    cast_children_with_caster(value, attribute, caster)
  end

  def cast_children_with_caster(value, attribute, caster)
    if attribute.caster == HashCast::Casters::ArrayCaster
      value.map do |val|
        caster.cast(val)
      end
    else
      caster.cast(value)
    end
  end

  def get_keys(hash)
    if options[:input_keys] != options[:output_keys]
      if options[:input_keys] == :symbol
        hash.keys.map(&:to_s)
      else
        hash.keys.map(&:to_sym)
      end
    else
      hash.keys
    end
  end

  def get_value(hash, key)
    if options[:input_keys] != options[:output_keys]
      if options[:input_keys] == :symbol
        hash[key.to_sym]
      else
        hash[key.to_s]
      end
    else
      hash[key]
    end
  end

  def check_unexpected_attributes_not_given!(input_hash_keys, casted_hash_keys)
    unexpected_keys = input_hash_keys - casted_hash_keys
    unless unexpected_keys.empty?
      raise HashCast::Errors::UnexpectedAttributeError.new("is not valid attribute name", unexpected_keys.first)
    end
  end

end
