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

        {
          group: :remove_key_prefix_inject_for,
          wrap: :remove_key_prefix_inject_hash_for
        }.each do |operation, inject|
          # rubocop:disable Layout/LineLength
          define_method :"#{operation}_prefix" do |array, key, keys, prefix, model = nil|
            # rubocop:enable Layout/LineLength
            compose do |ops|
              ops << t(operation, key, keys)
              ops << t(:map_array,
                       t(inject, key, prefix, model))
            end.call(array)
          end
        end

        def remove_key_prefix_inject_for(hash, key, prefix, model = nil)
          t(:map_value, key,
            t(:remove_key_prefix_inject_value, prefix, model)).call(hash)
        end

        def remove_key_prefix_inject_value(value, prefix, model = nil)
          compose do |ops|
            ops << t(:reject_array, t(:empty_hash?))
            ops << t(:map_array, t(:remove_key_prefix_inject, prefix, model))
          end.call(value)
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

        def remove_key_prefix_inject_hash_for(hash, key, prefix, model = nil)
          t(:map_value, key,
            t(:remove_key_prefix_inject, prefix, model)).call(hash)
        end

        def reject_array(array, function)
          Array(array).reject { |value| function[value] }
        end

        def empty_hash?(hash)
          hash.is_a?(Hash) && hash.values.all?(&:nil?)
        end
      end
    end
  end
end
