require 'spec_helper'

describe HashCast::Caster do
  describe "#cast" do

    class ContactCaster
      include HashCast::Caster

      attributes do
        hash :contact do
          string   :name
          integer  :age, optional: true
          float    :weight
          date     :birthday
          datetime :last_logged_in
          time     :last_visited_at
          hash :company do
            string :name
          end
          array :emails, each: :string
          array :social_accounts, each: :hash do
            string :name
            symbol :type
          end
        end
      end
    end

    it "should cast hash attributes" do
      input_hash = {
        contact: {
          name: "John Smith",
          age: "22",
          weight: "65.5",
          birthday: "2014-02-02",
          last_logged_in: "2014-02-02 10:10:00",
          last_visited_at: "2014-02-02 10:10:00",
          company: {
            name: "MyCo",
          },
          emails: [ "test@example.com", "test2@example.com" ],
          social_accounts: [
            {
              name: "john_smith",
              type: 'twitter',
            },
            {
              name: "John",
              type: :facebook,
            },
          ]
        }
      }

      casted_hash = ContactCaster.cast(input_hash)

      casted_hash.should == {
        contact: {
          name: "John Smith",
          age: 22,
          weight: 65.5,
          birthday: Date.parse("2014-02-02"),
          last_logged_in: DateTime.parse("2014-02-02 10:10:00"),
          last_visited_at: Time.parse("2014-02-02 10:10:00"),
          company: {
            name: "MyCo",
          },
          emails: [ "test@example.com", "test2@example.com" ],
          social_accounts: [
            {
              name: "john_smith",
              type: :twitter,
            },
            {
              name: "John",
              type: :facebook,
            },
          ]
        }
      }
    end

    describe "Custom casters" do
      class SettingsCaster
        include HashCast::Caster

        attributes do
          string :account
        end
      end

      class EmailCaster
        include HashCast::Caster

        attributes do
          string :address
        end
      end

      class CompanyCaster
        include HashCast::Caster

        attributes do
          string :name
          hash   :settings, caster: SettingsCaster
          array  :emails,  caster: EmailCaster
        end
      end

      it "should allow specify caster for nested hash attribute" do
        casted_hash = CompanyCaster.cast(
          name: 'Might & Magic',
          settings: {
            account: :'migthy_lord'
          },
          emails: [
            { address: :'test1@example.com' },
            { address: :'test2@example.com' },
          ]
        )

        casted_hash.should == {
          name: "Might & Magic",
          settings: { account: "migthy_lord" },
          emails: [
            { address: "test1@example.com" },
            { address: "test2@example.com" }
          ]
        }
      end
    end

    it "should raise error if some attribute can't be casted" do
      input_hash = {
        contact: {
          name: {},
          age: 22,
          weight: 65.5,
          birthday: Date.today,
          last_logged_in: DateTime.now,
          last_visited_at: Time.now,
          company: {
            name: "MyCo",
          },
          emails: [ "test@example.com", "test2@example.com" ],
          social_accounts: [
            {
              name: "john_smith",
              type: :twitter,
            },
            {
              name: "John",
              type: :facebook,
            }
          ]
        }
      }

      expect do
        ContactCaster.cast(input_hash)
      end.to raise_error(HashCast::Errors::CastingError, "contact[name] should be a string")
    end

    it "should raise error if some attribute wasn't given" do
      input_hash = {
        contact: {
          age: 22,
          weight: 65.5,
          birthday: Date.today,
          last_logged_in: DateTime.now,
          last_visited_at: Time.now,
          company: {
            name: "MyCo",
          },
          emails: [ "test@example.com", "test2@example.com" ],
          social_accounts: [
            {
              name: "john_smith",
              type: :twitter,
            },
            {
              name: "John",
              type: :facebook,
            }
          ]
        }
      }

      expect do
        ContactCaster.cast(input_hash)
      end.to raise_error(HashCast::Errors::MissingAttributeError, "contact[name] should be given")
    end

    it "should not raise error if attribute is optional" do
      input_hash = {
        contact: {
          name: "Jim",
          weight: 65.5,
          birthday: Date.today,
          last_logged_in: DateTime.now,
          last_visited_at: Time.now,
          company: {
            name: "MyCo",
          },
          emails: [ "test@example.com", "test2@example.com" ],
          social_accounts: [
            {
              name: "john_smith",
              type: :twitter,
            },
            {
              name: "John",
              type: :facebook,
            },
          ]
        }
      }

      expect do
        ContactCaster.cast(input_hash)
      end.to_not raise_error
    end

    it "raises error if skip_unexpected_attributes=false and unexpected attribute was given" do
      input_hash = {
        contact: {
          wrong_attribute: 'foo',
          name: "Jim",
          weight: 65.5,
          birthday: Date.today,
          last_logged_in: DateTime.now,
          last_visited_at: Time.now,
          company: {
            name: "MyCo",
          },
          emails: [ "test@example.com", "test2@example.com" ],
          social_accounts: [
            {
              name: "john_smith",
              type: :twitter,
            },
            {
              name: "John",
              type: :facebook,
            },
          ]
        }
      }

      expect do
        ContactCaster.cast(input_hash, skip_unexpected_attributes: false)
      end.to raise_error(HashCast::Errors::UnexpectedAttributeError, "contact[wrong_attribute] is not valid attribute name")
    end

    it "doesn't raise unexpected attributes error by default" do
      input_hash = {
        contact: {
          wrong_attribute: 'foo',
          name: "Jim",
          weight: 65.5,
          birthday: Date.today,
          last_logged_in: DateTime.now,
          last_visited_at: Time.now,
          company: {
            name: "MyCo",
          },
          emails: [ "test@example.com", "test2@example.com" ],
          social_accounts: [
            {
              name: "john_smith",
              type: :twitter,
            },
            {
              name: "John",
              type: :facebook,
            },
          ]
        }
      }

      expect do
        ContactCaster.cast(input_hash)
      end.not_to raise_error(HashCast::Errors::UnexpectedAttributeError)

    end

    it "should convert accept hash with string keys and cast them to symbol keys" do
      input_hash = {
        'contact' => {
          'name' => "John Smith",
          'age' => "22",
          'weight' => "65.5",
          'birthday' => "2014-02-02",
          'last_logged_in' => "2014-02-02 10:10:00",
          'last_visited_at' => "2014-02-02 10:10:00",
          'company' => {
            'name' => "MyCo",
          },
          'emails' => [ "test@example.com", "test2@example.com" ],
          'social_accounts' => [
            {
             'name' => "john_smith",
             'type' => 'twitter',
            },
            {
             'name' => "John",
             'type' => :facebook,
            },
          ]
        }
      }

      casted_hash = ContactCaster.cast(input_hash, input_keys: :string, output_keys: :symbol)

      casted_hash.should == {
        contact: {
          name: "John Smith",
          age: 22,
          weight: 65.5,
          birthday: Date.parse("2014-02-02"),
          last_logged_in: DateTime.parse("2014-02-02 10:10:00"),
          last_visited_at: Time.parse("2014-02-02 10:10:00"),
          company: {
            name: "MyCo",
          },
          emails: [ "test@example.com", "test2@example.com" ],
          social_accounts: [
            {
              name: "john_smith",
              type: :twitter,
            },
            {
              name: "John",
              type: :facebook,
            },
          ]
        }
      }
    end
  end

  context "checking invalid parameters" do
    it "should raise CaterNotFound exception if caster name is invalid" do
      expect do
        class WrongCaster
          include HashCast::Caster

          attributes do
            integr   :name
          end
        end
      end.to raise_error(HashCast::Errors::CasterNotFoundError)
    end
  end

  context "allow nil values" do
    before(:all) do
      class HomeCaster
        include HashCast::Caster

        attributes do
          string   :city
          integer  :zip, allow_nil: true
        end
      end
    end

    it "should allow nil values if allow_nil is set to true" do
      HomeCaster.cast(
        city: 'Kazan',
        zip: nil
      )
    end

    it "should allow nil values unless allow_nil is set to true" do
      expect do
        HomeCaster.cast(
          city: nil,
          zip: nil
        )
      end.to raise_error(HashCast::Errors::CastingError, "city should be a string")
    end
  end

  context "string caster" do
    before(:all) do
      class HomeCaster
        include HashCast::Caster

        attributes do
          string   :city
        end
      end
    end

    after{ HashCast.config.validate_string_null_byte = nil }

    it "should allow null byte if validate_string_null_byte config is set to false" do
      HashCast.config.validate_string_null_byte = false
      HomeCaster.cast(city: "\u0000")
    end

    it "should not allow null byte if validate_string_null_byte config by default" do
      expect do
        HomeCaster.cast(city: "\u0000")
      end.to raise_error(HashCast::Errors::CastingError, "city contains invalid characters")
    end
  end
end
