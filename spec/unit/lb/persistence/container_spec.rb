# frozen_string_literal: true

require 'spec_helper'

describe LB::Persistence, '#container' do
  include_context 'settings'

  subject { object.container }

  let(:object) { described_class.new(settings) }

  it 'should return container' do
    expect(subject).to be_a(ROM::Container)
  end
end
