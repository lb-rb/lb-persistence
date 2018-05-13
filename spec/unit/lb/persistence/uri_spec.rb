# frozen_string_literal: true

require 'spec_helper'

describe LB::Persistence, '#uri' do
  include_context 'settings'

  subject { object.uri }

  let(:object) { described_class.new(settings) }

  it 'should return database uri' do
    expect(subject).to be(database_uri)
  end
end
