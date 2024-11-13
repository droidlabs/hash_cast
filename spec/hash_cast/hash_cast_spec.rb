require 'spec_helper'

describe HashCast do

  describe ".create" do
    it "should cast hash attributes" do
      input_hash = {
        contact: {
          name: "John Smith",
          age:  22,
          company: {
            name: "MyCo",
          }
        }
      }

      caster = HashCast.create do
        hash :contact do
          string   :name
          integer  :age
          hash :company do
            string :name
          end
        end

        def registered?
          true
        end
      end

      casted_hash = caster.cast(input_hash)

      expect(casted_hash.object_id).to_not eq(input_hash.object_id)
      expect(casted_hash).to eq(input_hash)
    end
  end
end
