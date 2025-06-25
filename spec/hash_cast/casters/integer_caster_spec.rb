require 'spec_helper'

describe HashCast::Casters::IntegerCaster do
  subject { HashCast::Casters::IntegerCaster }

  it "should cast from a numeric string" do
    result = subject.cast("123", :number)
    expect(result).to eq(123)
  end

  it "should cast from an positive integer" do
    result = subject.cast(10_000, :number)
    expect(result).to eq(10_000)
  end

  it "should cast from a negative integer" do
    result = subject.cast(-10_000, :number)
    expect(result).to eq(-10_000)
  end

  it "should cast from a zero" do
    result = subject.cast(0, :number)
    expect(result).to eq(0)
  end

  it "should not cast from a random string" do
    expect {
      subject.cast("test", :number)
    }.to raise_error(HashCast::Errors::CastingError, "is invalid integer")
  end

  it "should not cast from an array" do
    expect {
      subject.cast([1], :number)
    }.to raise_error(HashCast::Errors::CastingError, "should be a integer")
  end

  it "only allow values larger than max integer range" do
    expect {
      subject.cast(2**40, :number)
    }.to raise_error(HashCast::Errors::CastingError, "should be within allowed range")
  end

  it "only allow values smaller than min integer range" do
    expect {
      subject.cast(2**40 * -1, :number)
    }.to raise_error(HashCast::Errors::CastingError, "should be within allowed range")
  end
end
