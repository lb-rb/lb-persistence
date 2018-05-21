# frozen_string_literal: true

module LB
  class Persistence
    # LB transproc functions
    module Functions
      extend Transproc::Registry
      extend Transproc::Composer

      import Transproc::Coercions
      import Transproc::Conditional
      import Transproc::ArrayTransformations
      import Transproc::HashTransformations
      import Transproc::ClassTransformations
      import Transproc::ProcTransformations

      class << self
        def debug_p(value)
          p value
        end

        def debug_pp(value)
          pp value
        end

        def debug_puts(value)
          puts value
        end

        def remove_prefix(key, prefix)
          remove_prefix_from_key(key.to_s, prefix).to_sym
        end

        def remove_prefix_from_key(key, prefix)
          key.start_with?(prefix) ? key.gsub(/^#{prefix}/, '') : key
        end

        def group_prefix(array, key, keys, prefix, model = nil)
          compose do |ops|
            ops << t(:group, key, keys)
            ops << t(:map_array,
                     t(:remove_key_prefix_inject_for, key, prefix, model))
          end.call(array)
        end

        def remove_key_prefix_inject_for(hash, key, prefix, model = nil)
          t(:map_value, key,
            t(:map_array,
              t(:remove_key_prefix_inject, prefix, model))).call(hash)
        end

        def remove_key_prefix_inject(keys, prefix, model = nil)
          compose do |ops|
            ops << t(:remove_key_prefix, prefix)
            ops << t(:inject_if_given, model)
          end.call(keys)
        end

        def remove_key_prefix(keys, prefix)
          t(:map_keys, t(:remove_prefix, prefix)).call(keys)
        end

        def inject_if_given(value, model)
          t(:guard, ->(_v) { !model.nil? },
            t(:constructor_inject, model)).call(value)
        end

        def inject_array(array, model)
          t(:map_array, t(:constructor_inject, model)).call(array)
        end
        alias model inject_array
      end
    end
  end
end
