# frozen_string_literal: true

module LB
  class Persistence
    module Relation
      # Helper for joining relations
      module Joins
        def left_join_all_qualified(joins)
          left_join_all(qualified, joins)
        end

        def left_join_all(base, joins)
          join_all(:left_join, base, joins)
        end

        def join_all(type, base, joins)
          joins.each do |relation, on|
            base = base.__send__(type, relation, qualify_on(on))
          end
          base
        end

        def qualify_on(on)
          on.to_h do |source, target|
            source = source.qualified if source.respond_to?(:qualified)
            target = target.qualified if target.respond_to?(:qualified)
            [source, target]
          end
        end

        def prefixed(relation,
                     prefix = Dry::Core::Inflector
                       .singularize(relation.schema.name.dataset))
          relation.qualified.prefix(prefix).schema.attributes
        end
      end
    end
  end
end
