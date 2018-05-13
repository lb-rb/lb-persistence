# frozen_string_literal: true

require 'spec_helper'

describe LB::Persistence, '.new' do
  include_context 'settings'

  subject { object.new(settings) }

  let(:object) { described_class }

  it 'should return config' do
    expect(subject).to be_a(object)
  end
end
