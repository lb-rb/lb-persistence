# frozen_string_literal: true

require 'spec_helper'

describe LB::Persistence::Functions, '.wrap_prefix' do
  subject { object.call(data) }

  let(:object) do
    described_class.t(:wrap_prefix, key, keys, prefix, nested_class)
      .>> described_class.t(:model, model_class)
  end

  let(:key) { :item }
  let(:keys) { [:item_a] }
  let(:prefix) { 'item_' }

  let(:model_class) do
    nested = nested_class
    Class.new(Dry::Struct) do
      module Types
        include Dry::Types.module
      end

      attribute :a,    Types::Strict::String
      attribute :item, nested
    end
  end

  let(:nested_class) do
    Class.new(Dry::Struct) do
      module Types
        include Dry::Types.module
      end

      attribute :a, Types::Strict::String
    end
  end

  let(:data) do
    [
      { a: 'a1', item_a: 'item_a1' },
      { a: 'a2', item_a: 'item_a3' }
    ]
  end

  let(:expected_hash_values) do
    [
      { a: 'a1', item: { a: 'item_a1' } },
      { a: 'a2', item: { a: 'item_a3' } }
    ]
  end

  it 'should group hash' do
    expect(subject.map(&:to_h)).to eq(expected_hash_values)
  end
end
