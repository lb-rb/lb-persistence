# frozen_string_literal: true

require 'spec_helper'

describe LB::Persistence::Functions, '.group_prefix' do
  subject { object.call(data) }

  let(:object) do
    described_class.t(:group_prefix, key, keys, prefix, nested_class)
      .>> described_class.t(:model, model_class)
  end

  let(:key) { :items }
  let(:keys) { [:item_a] }
  let(:prefix) { 'item_' }

  let(:model_class) do
    nested = nested_class
    Class.new(Dry::Struct) do
      module Types
        include Dry.Types(default: :nominal)
      end

      attribute :a, Types::Strict::String
      attribute :items, Types::Strict::Array.of(nested)
    end
  end

  let(:nested_class) do
    Class.new(Dry::Struct) do
      module Types
        include Dry.Types(default: :nominal)
      end

      attribute :a, Types::Strict::String
    end
  end

  let(:data) do
    [
      { a: 'a1', item_a: 'item_a1' },
      { a: 'a1', item_a: 'item_a2' },
      { a: 'a2', item_a: 'item_a3' }
    ]
  end

  let(:expected_hash_values) do
    [
      { a: 'a1', items: [{ a: 'item_a1' }, { a: 'item_a2' }] },
      { a: 'a2', items: [{ a: 'item_a3' }] }
    ]
  end

  it 'should group hash' do
    expect(subject.map(&:to_h)).to eq(expected_hash_values)
  end
end
