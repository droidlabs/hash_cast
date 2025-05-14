require 'spec_helper'

describe HashCast::Casters::StringCaster do
  subject { HashCast::Casters::StringCaster }

  it "should cast a string" do
    result = subject.cast("foobar", :name)
    expect(result).to eq("foobar")
  end

  context "string size validation" do
    after{ 
      HashCast.config.string_size_validator_enabled = nil
      HashCast.config.string_size_validator_limit = nil
    }

    it "should not raise an error for large string by default" do
      result = subject.cast("a" * 10_000, :name)
      expect(result).to eq("a" * 10_000)
    end

    it "should raise an error for large string when validation is enabled" do
      HashCast.config.string_size_validator_enabled = true
      HashCast.config.string_size_validator_limit = 1000

      expect {
        subject.cast("a" * 10_000, :ids)
      }.to raise_error(HashCast::Errors::CastingError, "string is too large")
    end

    it "should allow overriding the callback" do
      HashCast.config.string_size_validator_enabled = true
      HashCast.config.string_size_validator_limit = 1000
      HashCast.config.string_size_validator_callback = lambda { |value, name, options|
        raise HashCast::Errors::UnexpectedAttributeError, 'test'
      }

      expect {
        subject.cast("a" * 10_000, :ids)
      }.to raise_error(HashCast::Errors::UnexpectedAttributeError, "test")
    end
  end
end
