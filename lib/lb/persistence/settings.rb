# frozen_string_literal: true

module LB
  class Persistence
    # Settings supplied to LB::Persistence
    class Settings < Dry::Struct
      attribute :source_dir, Types::Strict::String
      attribute :namespace, Types::Strict::String
      attribute :database_uri, Types::Strict::String
    end
  end
end
