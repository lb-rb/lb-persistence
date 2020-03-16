# frozen_string_literal: true

module LB
  class Persistence
    # Custom Types
    module Types
      include Dry.Types(default: :nominal)
    end
  end
end
