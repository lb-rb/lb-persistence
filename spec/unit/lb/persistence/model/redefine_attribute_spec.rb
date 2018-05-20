# frozen_string_literal: true

require 'spec_helper'

describe LB::Persistence::Model::Attributes, '#redefine_attribute' do
  include_context 'settings'

  subject { object }

  let(:model_base_class) do
    Class.new(Dry::Struct) do
      module Types
        include Dry::Types.module
      end

      attribute :a, Types::Strict::Symbol
      attribute :b, Types::Strict::String
      attribute :c, Types::Strict::Hash
    end
  end

  let(:model_child_class) do
    Class.new(model_base_class) do
      extend LB::Persistence::Model::Attributes

      redefine_attribute :b, Types::Strict::Bool
    end
  end

  let(:object) { model_child_class.new(values) }

  let(:base_values) do
    {
      a: :symbol,
      c: { key: 'value' }
    }
  end

  let(:values) { base_values.merge(b: true) }

  it 'should create model with redefined attribute' do
    expect(subject.b).to be(true)
  end

  context 'with invalid value' do
    let(:values) { base_values.merge(b: 'true') }
    let(:expected_msg) { /has invalid type for #{Regexp.escape(':b')}/ }

    it 'should not create model with old attribute' do
      expect { subject }.to raise_error(Dry::Struct::Error, expected_msg)
    end
  end
end
