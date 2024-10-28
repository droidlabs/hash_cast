require 'hash_cast/version'
require 'hash_cast/errors'
require 'hash_cast/config'
require 'hash_cast/casters'
require 'hash_cast/concern.rb'
require 'hash_cast/metadata/attribute'
require 'hash_cast/attributes_parser'
require 'hash_cast/attributes_caster'
require 'hash_cast/caster'

module HashCast
  @@casters = {}

  # Defines caster without adding own class
  # @note Not yet implemented
  def self.create(&block)
  end

  # Returns list of defined casters
  def self.casters
    @@casters
  end

  # Adds new casters to HashCast
  # Allow extend HashCast with your own casters
  # @param caster_name [Symbol] caster name
  # @param caster      [Class]  caster
  def self.add_caster(caster_name, caster)
    @@casters[caster_name] = caster
  end

  def self.config
    @@config ||= HashCast::Config.new
  end
end

HashCast.add_caster(:array,    HashCast::Casters::ArrayCaster)
HashCast.add_caster(:boolean,  HashCast::Casters::BooleanCaster)
HashCast.add_caster(:date,     HashCast::Casters::DateCaster)
HashCast.add_caster(:datetime, HashCast::Casters::DateTimeCaster)
HashCast.add_caster(:float,    HashCast::Casters::FloatCaster)
HashCast.add_caster(:hash,     HashCast::Casters::HashCaster)
HashCast.add_caster(:integer,  HashCast::Casters::IntegerCaster)
HashCast.add_caster(:string,   HashCast::Casters::StringCaster)
HashCast.add_caster(:symbol,   HashCast::Casters::SymbolCaster)
HashCast.add_caster(:time,     HashCast::Casters::TimeCaster)
