# frozen_string_literal: true

module LB
  class Persistence
    module Model
      # Helper for dry-struct attributes
      module Attributes
        def delete_attribute(name)
          @schema.delete(name)
          equalizer.instance_variable_get('@keys').delete(name)
          superclass.instance_variable_get('@schema').delete(name)
          @constructor = Dry::Types['coercible.hash']
                         .public_send(constructor_type, @schema)

          self
        end

        def redefine_attribute(name, type)
          delete_attribute(name)
          attribute(name, type)
        end
      end
    end
  end
end
