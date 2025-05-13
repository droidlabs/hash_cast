require 'spec_helper'

describe HashCast::Casters::ArrayCaster do
  subject { HashCast::Casters::ArrayCaster }

  it "should cast array" do
    result = subject.cast([1,2,3], :ids)
    expect(result).to eq([1,2,3])
  end

  it "should raise an error for non-array" do
    expect {
      subject.cast(1, :ids)
    }.to raise_error(HashCast::Errors::CastingError, "should be an array")
  end

  context "array size validation" do
    after{ 
      HashCast.config.array_size_validator_enabled = nil
      HashCast.config.array_size_validator_limit = nil
    }

    it "should not raise an error for large array by default" do
      result = subject.cast([1] * 10_000, :ids)
      expect(result).to eq([1] * 10_000)
    end

    it "should raise an error for large array when validation is enabled" do
      HashCast.config.array_size_validator_enabled = true
      HashCast.config.array_size_validator_limit = 1000

      expect {
        subject.cast([1] * 10_000, :ids)
      }.to raise_error(HashCast::Errors::CastingError, "array is too large")
    end
  end
end
